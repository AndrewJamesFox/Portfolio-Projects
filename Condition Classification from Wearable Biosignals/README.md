# Condition Classification from Wearble Biosignals

# Project Overview

This is a personal project completed in Novemeber and December of 2025. I explore the classification of physiological states from multi-modal biosignal data collected via chest- and wrist-worn sensors. The goal is to automatically distinguish between the states of Baseline, Stress, Amusement, and Meditation using a Random Forest classifier and LOSO cross-validation.

## Goal

Classify physiological conditions/states from multi-modal biosignals collected via chest- and wrist-worn sensors. The objective is to demonstrate cross-subject classification with interpretable results.

## Approach

I resample all signals to a common 64hz and normalize per subject for LOSO cross-validation.

I window the signals into 10-second segments with 5-second overlap, extracting summary statistics per signal (mean, std, min, max, peak-to-peak) as oppose to feedinng the model raw signal data. This was memory-efficient and created nice fixed-length vectors for the Random Forest. It also may reduce certain noise in the signals.

I trained a Random Forest classifier using Leave-One-Subject-Out (LOSO) cross-validation, ensuring evaluation on unseen participants.

## Results

LOSO evaluation shows accuracy between 0.43 and 0.80 per subject, with overall macro F1-score of ~0.54.

The model seems to predict Baseline and Stress quite well, and predicts Meditation moderately well, but struggles with Amusement.

The confusion matrix and the class-wise F1 metrics provide insight into per-class performance and highlight areas for improvement.

## Data

The dataset is from https://uni-siegen.sciebo.de/s/HGdUkoNlW1Ub0Gx from https://archive.ics.uci.edu/dataset/465/wesad+wearable+stress+and+affect+detection

Data was collected from 15 participants (subjects 2–17, with 1 and 12 missing), with multi-modal signals:
- Chest: ACC, ECG, EDA, EMG, RESP, TEMP; all sampled at 700hz
- Wrist: ACC, BVP, EDA, TEMP; sampled at 32, 64, 4 and 4 hz, respectively

I resampled data to 64hz. This aligned all signals to a commonn sampling rate and esnured synchronized windows across device signals. I also normalized data per subject during LOSO model training.

Each signal is split into 10-second windows with 5-second overlap, with the majority label per window calculated using a minimum 50% threshold. This reduced memory requirement and created fixed-length vectors for training.


## Modeling

I trained and evaluated a Random Forest Classifier:
- n_estimators=200
- max_depth=15
- min_samples_leaf=20

I trained the model on all subjects except the one being tested, using Leave-One-Subject-Out (LOSO) cross-validation. This approach is commonly used with multi-subject data because it evaluates the model’s ability to generalize to unseen participants while respecting the unique physiological characteristics of each individual.

## Evaluation

I assesed the model on accuracy, F1-score, class-wise F1-scores, and a global confusion matrix.

### LOSO results (per-subject accuracy/F1):

Subject 2: Acc=0.427, F1=0.211

Subject 3: Acc=0.729, F1=0.607

Subject 4: Acc=0.637, F1=0.475

Subject 5: Acc=0.701, F1=0.560

Subject 6: Acc=0.741, F1=0.587

Subject 7: Acc=0.586, F1=0.459

Subject 8: Acc=0.712, F1=0.581

Subject 9: Acc=0.801, F1=0.660

Subject 10: Acc=0.740, F1=0.568

Subject 11: Acc=0.735, F1=0.566

Subject 13: Acc=0.561, F1=0.370

Subject 14: Acc=0.531, F1=0.435

Subject 15: Acc=0.578, F1=0.513

Subject 16: Acc=0.774, F1=0.639

Subject 17: Acc=0.741, F1=0.588


### Global confusion matrix

<img width="562" height="470" alt="Screenshot 2025-12-13 at 9 18 23 PM" src="https://github.com/user-attachments/assets/9470d9cd-b1ba-4a30-a045-6e69688d40fe" />


Baseline and Stress conditions were predicted quite reliably. Amusement, however, is rarely predicted correctly, likely due to class imbalance. Meditation is predicted moderately well.

## Class-wise F1-scores:

                 precision recall    f1-score  support

    Baseline     0.67      0.85      0.75      3522
    Stress       0.76      0.75      0.76      1994
    Amusement    0.03      0.01      0.01      1114
    Meditation   0.66      0.63      0.64      2361

    accuracy                         0.67      8991
    macro avg    0.53      0.56      0.54      8991
    weighted avg 0.61      0.67      0.63      8991


## Interpretation

The model performs well on common states like the baseline state and Stress, but struggles with minority classes like Amusement, demonstrating challenges of inter-subject variability and class imbalance in physiological signals.



## Future Work / Considerations

The performance could likely be improved with oversampling or augmentation. I could also explore deep learning models like CNNs or LSTMs that excel with temporal dependencies and time-series data.
