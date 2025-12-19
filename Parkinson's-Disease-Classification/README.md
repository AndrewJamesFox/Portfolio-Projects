# Parkinson's Disease Classification

# Project Overview

This is a personal machine learning project exploring the classification of Parkinson’s disease using vocal frequency–based features extracted from speech recordings. The goal is to evaluate whether non-invasive voice biomarkers can distinguish Parkinson’s patients from healthy controls using classical supervised learning models.

# Goal

Classify Parkinson’s disease patients versus healthy individuals using vocal frequency features derived from speech recordings, and compare the performance and interpretability of multiple supervised machine learning models.

# Dataset

The dataset (parkinsons_data.csv) was sourced from Kaggle and originates from a well-known Parkinson’s voice analysis dataset. The dataset used can be found [here](https://www.kaggle.com/datasets/jainaru/parkinson-disease-detection).

There were 195 voice recordings from multiple subjects. It was a binary target variable:
- status = 1 → Parkinson’s disease
- status = 0 → Healthy control

Each sample includes pre-extracted acoustic features describing:
- Fundamental frequency (Fo, Fhi, Flo)
- Frequency variation (jitter)
- Amplitude variation (shimmer)
- Harmonicity (HNR, NHR)
- Nonlinear dynamical measures (RPDE, DFA, PPE)

# Data Preparation & EDA

I parsed subject ID and recording number from the original name column for cleaner analysis and visualization, and verified data integrity by seeing there were no missing values.

I conducted exploratory data analysis using pandas, seaborn, and matplotlib, including:
- Feature distributions
- Correlation matrix and heatmap
- Comparison plots of healthy vs. Parkinson’s recordings across key vocal features

EDA revealed there were clear differences between healthy and Parkinson’s patients in multiple vocal measures, supporting downstream classification.

# Feature Selection

To balance performance and interpretability, I created three feature subsets:
- All features – full feature set
- Literature-aligned features – features commonly used in Parkinson’s speech research (e.g., jitter, shimmer, RPDE, DFA, PPE)
- Selective features – representative features from each vocal measurement category

This allowed there to be comparison between comprehensive and clinically motivated feature sets, and was motivated by potential for some subsets to prove better classifiers. 

# Modeling

The dataset was split into 70% training and 30% testing, trained and evaluated on the following supervised models:
- Decision Trees (Gini and Entropy criteria)
- Random Forest
- k-Nearest Neighbors (kNN)
- Support Vector Machine (linear kernel)

Feature normalization was applied for distance- and margin-based models (kNN and SVM). An elbow plot was used to select the optimal number of neighbors for kNN.

# Evaluation

Models were evaluated using:
- Accuracy
- Precision, recall, and F1-score
- Confusion matrices

# Key Results

Best-performing models (kNN and linear SVM) achieved ~92% test accuracy

Decision Trees performed competitively despite the small dataset, and better than random forest likely due to small dataset size in which random forest underfit on.

Literature-aligned feature subsets performed similarly to the full feature set, supporting clinical relevance.

Multiple classical models were capable of distinguishing Parkinson’s patients from healthy controls using vocal features alone, reinforcing their effectiveness.

# Interpretation

This project demonstrates that vocal frequency features can be effective non-invasive biomarkers for Parkinson’s disease classification. Strong performance from simple and interpretable models highlights the value of well-engineered features in small clinical datasets.

# Limitations

Dataset size is relatively small, which limits generalization across subjects.

Recordings were treated independently, which may introduce subject-level leakage.

Vocal features alone do not capture the full clinical complexity of Parkinson’s disease.


# Future Work

I should implement subject-level cross-validation to better assess generalization.

I should evaluate additional metrics such as ROC–AUC

I could explore dimensionality reduction or feature selection techniques.

I could extend the training to raw audio signals and temporal models if available.

# Other

Andrew Fox
<br>2024-08-09

This project was completed as the capstone project for the Data Mining class taught by Professor Kiran Trivedi during Northeastern University's Master's of Data Analytics Enginnering program.

## Links
The dataset used can be found [here](https://www.kaggle.com/datasets/jainaru/parkinson-disease-detection).

## Versions
This project was completed in Jupyter Notebooks with Python 3 on a Macbook Pro.

*Jupyter*<br>
7.0.8

*Python*<br>
3.11.8

*Macbook*<br>
Ventura 13.6.4
