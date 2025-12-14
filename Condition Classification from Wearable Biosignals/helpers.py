## HELPER FUNCTIONS
from src.config import *
import os
import pickle
import pandas as pd
import numpy as np


# GET RAW DATA
def get_rawdata():
    return pickle.load(open(RAWDATA, "rb"))


# CONVERT RAW DATA DICTIONARY INTO A DATAFRAME
'''
This converts the raw data from a dictionary into a pandas DataFrame, capable of creating one for the chest signal, per subject, or a dictionary of dataframes for the wrist signal per subject, as those are sampled at different rates and thus cannot be coalesced into a single dataframe. 

Returns a DataFrame for a single subject's single device data.
    rawdata : dict
        The dictionary of all the rawdata.
    subnum : int
        subject number; either 2-17 excluding 12
    device : str
        recording device; either 'chest' or 'wrist'
'''
def raw2df(rawdata, subnum, device):
    device_data = rawdata[subnum]['signal'][device] #retrieve device data

    # Chest data can go into single df
    if device == "chest":
        df = {}
        for sig_name, sig_data in device_data.items():
            sig_data = np.asarray(sig_data).squeeze()
            # ACC signal has 3 columns
            if sig_name == "ACC" and sig_data.ndim == 2 and sig_data.shape[1] == 3:
                df["ACC_X"] = sig_data[:, 0]
                df["ACC_Y"] = sig_data[:, 1]
                df["ACC_Z"] = sig_data[:, 2]
            else:
                df[sig_name] = sig_data
        
        # Add labels
        df["label"] = np.asarray(rawdata[subnum]['label'])
        return pd.DataFrame(df)

    # Wrist data must go into dict of dfs
    elif device == "wrist":
        dfs = {}
        for sig_name, sig_data in device_data.items():
            sig_data = np.asarray(sig_data).squeeze()
                # ACC signal has 3 columns
            if sig_name == "ACC" and sig_data.ndim == 2 and sig_data.shape[1] == 3:
                dfs["ACC_X"] = pd.DataFrame({"ACC_X": sig_data[:, 0]})
                dfs["ACC_Y"] = pd.DataFrame({"ACC_Y": sig_data[:, 1]})
                dfs["ACC_Z"] = pd.DataFrame({"ACC_Z": sig_data[:, 2]})
            else:
                dfs[sig_name] = pd.DataFrame({sig_name: sig_data})
        return dfs


# WINDOW DATA
def window_data_features(subnum, win_size=10, step=5, hz=64):
    ## LOADING
    # load preprocessed signal data
    chest_data = pd.read_csv(os.path.join(PRODIR, "chest", f"s{subnum}chest64.csv"))
    wrist_data = pd.read_csv(os.path.join(PRODIR, "wrist", f"s{subnum}wrist64.csv"))
    
    # merge chest and wrist data into single time-aligned feature matrix
    df = chest_data.merge(wrist_data, left_index=True, right_index=True, suffixes=("_chest", "_wrist"))

    ## LABELS AND FEATURES
    # get labels and features
    labels = df["label"].values
    features = df.drop(columns=["label"]).values

    ## CALCULATE WINDOWS
    # calculate window and step size
    win_len = win_size * hz
    step = step * hz

    # create sliding windows
    X, y = [], []
    # loop over signal with step-sized overlap
    for start in range(0, len(df) - win_len + 1, step):
        end = start + win_len
        
        # get feature and label windows
        x_win = features[start:end]
        y_win = labels[start:end]

        # calculate majority label in each window
        vals, counts = np.unique(y_win, return_counts=True)
        maj_idx = np.argmax(counts)
        # disregard if majority label isn't 50% of window
        if counts[maj_idx] / win_len < 0.5:
            continue

        ## FEATURE EXTRACTION
        # produce a fixed-length vector of summary statistics per window
        feat_vec = []
        for ch in range(x_win.shape[1]):
            sig = x_win[:, ch]
            feat_vec.extend([
                np.mean(sig),
                np.std(sig),
                np.min(sig),
                np.max(sig),
                np.ptp(sig)
            ])

        # results
        X.append(feat_vec)
        y.append(vals[maj_idx])

    return np.asarray(X, dtype=np.float32), np.asarray(y)
