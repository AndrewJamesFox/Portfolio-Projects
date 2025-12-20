# Disaster Tweet Classification with NLP

2025-04-21

This project was a semester-long project for the Applied Natural Language Processing in Engineering (IE 7500) class taught by Professor Ramin Mohammadi during my fourth semester in Northeastern University's Master's of Data Analytics Engineering program.
It was a group project completed with two other classmates. My contribution to the coding requirements of the project consisted of neural networks, recurrent neural networks, and LSTMs.

This is an end-to-end natural language processing (NLP) project to classify tweets as disaster-related or non-disaster-related. The motivation is to help emergency services and response organizations identify relevant, time-sensitive information from social media data.

The project compares traditional machine learning models, deep learning approaches, and transformer-based architectures to understand performance tradeoffs and the importance of contextual language modeling.

# Project Overview

Task: Binary text classification (disaster vs. non-disaster)

Data: Labeled tweet dataset sourced from Kaggle

Approach: Classical ML → Neural Networks → Transformers

Evaluation: F1-score, precision, recall, confusion matrices

# Dataset

Publicly available Kaggle dataset containing labeled tweets. Rows with missing or ambiguous labels were removed. Target labels were converted to a numerical binary format for training. Only tweet text was used for modeling; irrelevant features were dropped.

# Preprocessing

Text preprocessing was intentionally kept lightweight:
- URL removal
- Lowercasing
- Punctuation removal

An ablation study was conducted to test:
- Lemmatization
- Stop-word removal
- Combinations of both

These steps showed no meaningful performance improvement for simpler neural architectures, so minimal preprocessing was used for the final models.

# Models Evaluated

## Traditional Machine Learning
- Logistic Regression
- Support Vector Machine (SVM)
- Naive Bayes
- Random Forest
  - Word2Vec embeddings were tested with Random Forests but did not significantly improve performance.

## Deep Learning
- Dense Neural Networks
- Recurrent Neural Networks (RNNs)
- Long Short-Term Memory (LSTM) networks
- LSTM with dropout regularization

Hyperparameter tuning was performed on network depth, activation functions, and number of epochs.

## Transformer
- BERT (best-performing model)

# Evaluation

Models were evaluated using:
- F1-score (primary metric)
- Precision and recall
- Confusion matrices
- Bar plots were used to visually compare performance across models and architectures.

# Results

BERT achieved the highest overall performance, confirming the importance of contextual understanding in short-text classification.

LSTM models with dropout outperformed simpler neural networks and traditional ML models.

Dense neural networks underperformed, likely due to data size and limited regularization.

Increased preprocessing complexity provided minimal benefit compared to model choice.

# Future Work

Experiment with additional pretrained embeddings (e.g., GloVe).

Implement bidirectional LSTMs for improved contextual modeling.

Incorporate Named Entity Recognition (NER) to extract locations and disaster-specific entities.

Explore domain-specific entity classes tailored to emergency response use cases.

# Tech Stack

Python

NumPy, Pandas

scikit-learn

TensorFlow / Keras

Hugging Face Transformers

Matplotlib, Seaborn


## Versions
This project was completed in python in Jupyter Notebooks on a Macbook Pro laptop.

*Jupyter Notebooks*<br>
Version: 7.0.8

*Python*<br>
Python 3.11.8

*MacOS*<br>
Version 13.7.2
