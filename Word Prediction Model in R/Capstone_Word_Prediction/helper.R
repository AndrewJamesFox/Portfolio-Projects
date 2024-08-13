## Helper R script file for Shiny App

#' Returns the last n words of a text string
#' @param text text to backoff
#' @param n number of words at end of text to return
#' @details requires 'stringr' package
backoff <- function(text, n){
  if (trimws(text) == ""){
    stop("Input words")
  }
  if(n <= 0){
    stop("n must be > 0")
  }
  if(n > length(str_split_1(text, " "))){
    stop("n cannnot be longer than length of text")
  }
  
  words <- character()
  while (n > 0){
    word <- word(text, -n)
    words <- paste(words, word)
    n <- n-1
  }
  trimws(words)
}

#' Returns the bigram table where bigrams first word matches text.
#' The probababilities of the bigrams are adjusted to represent those of matches.
#' @param text character to match
#' @param bitbl table of bigrams
#' @param adjProb adjust bigram probabilites to represent that of only matched bigrams?
#' @details requires 'stringr' package
#' 
matchingBigrams <- function(text, bitbl, adjProb=T){
  text <- word(text, -1) #redfine text to previous word
  newbitbl <- bitbl[word(bitbl$bigrams, 1) == text, ]
  if (nrow(newbitbl) == 0){
    return(NULL)
  }
  
  if(adjProb==T){
    probs <- c()
    newFreqSum <- sum(newbitbl$Freq)
    for (freq in newbitbl$Freq){
      probs <- c(probs, freq / newFreqSum)
    }
    newbitbl$Prob <- probs
    return(newbitbl)
  }
  return(newbitbl)
}
#' Returns the trigram table where trigrams first two words matches text
#' @param text character to match
#' @param bitbl table of trigrams
#' @param adjProb adjust trigram probabilites to represent that of only matched trigrams?
#' @details requires 'stringr' package
#' 
matchingTrigrams <- function(text, tritbl, adjProb=T){
  if (length(str_split_1(text, " ")) <= 1){
    stop("'text' must be at least two words long to match it to a trigram.")
  }
  
  text <- word(text, -(2:1)) #redfine text to previous 2 words
  newtritbl <- tritbl[word(tritbl$trigrams, 1) == text[1] & 
                        word(tritbl$trigrams, 2) == text[2], ]
  if (nrow(newtritbl) == 0){
    return(NULL)
  }
  
  if(adjProb==T){
    probs <- c()
    newFreqSum <- sum(newtritbl$Freq)
    for (freq in newtritbl$Freq){
      probs <- c(probs, freq / newFreqSum)
    }
    newtritbl$Prob <- probs
    return(newtritbl)
  }
  return(newtritbl)
}

## Model2
model2 <- function(text, unitbl, bitbl, tritbl, n){
  words <- c()
  len <- length(str_split_1(text, " "))
  
  if (trimws(text) == ""){
    words <- c(words, as.character(unitbl$unigrams[1:n]))
    return(words)
  }
  
  if (len == 1){
    matches <- matchingBigrams(text, bitbl)
    if (!is.null(matches)){
      if (nrow(matches) < n){
        words <- c(words, as.character(unitbl$unigrams[1:n]))
      }
    }
    words <- c(words, as.character(word(matches$bigrams[1:n], -1)))
    return(words)
  }
  
  if (len >= 2){
    text <- backoff(text, 2) #get previous 2 words (preBigram)
    matches <- matchingTrigrams(text, tritbl)
    if(is.null(matches)){ #if no matches, backoff to n-1Gram
      text <- backoff(text, 1) #get previous sord (preUnigram)
      matches <- matchingBigrams(text, bitbl)
      if (is.null(matches)){ #if no matches, return most common words
        words <- c(words, as.character(unitbl$unigrams[1:n]))
      }
      #if not enough words, backoff to unigrams
      if (!is.null(matches)){
        if (nrow(matches) < n){
          words <- c(words, as.character(unitbl$unigrams[1:n]))
        }
      }
      words <- c(words, as.character(word(matches$bigrams[1:n], -1)))
    }
    #if not enough words, backoff to unigrams
    if (!is.null(matches)){
      if (nrow(matches) < n){
        text <- backoff(text, 1)
        matches <- matchingBigrams(text, bitbl)
        words <- c(words, as.character(word(matches$bigrams[1:n], -1)))
      }
    }
    words <- c(words, as.character(word(matches$trigrams[1:n], -1)))
  }
  return(words)
}