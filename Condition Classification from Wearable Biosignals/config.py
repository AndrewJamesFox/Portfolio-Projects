import os
import matplotlib.colors as mcolors

# directory paths
ROOT = os.getcwd()
RAWDIR = os.path.join(ROOT, "data", "raw")
PRODIR = os.path.join(ROOT, "data", "processed")

# rawdata path
RAWDATA = os.path.join(RAWDIR, "all_rawdata.pkl")

# subject ids - subject 1 and 12 data are missing
SUB_IDS = [2,3,4,5,6,7,8,9,10,11,13,14,15,16,17]

# sampling rates for each rrecording device
HZs = {
    "chest": {"ACC": 700, "ECG": 700, "EDA": 700, "EMG": 700, "RESP": 700, "TEMP": 700},
    "wrist": {"ACC": 32, "BVP": 64, "EDA": 4, "TEMP": 4}
}
CHEST_HZ = 700

# labels
LABELS = {
    0: "Undefined",
    1: "Baseline",
    2: "Stress",
    3: "Amusement",
    4: "Meditation"
}
LABEL_NAMES = list(LABELS.values())

# label cmap for plotting
LABEL_CMAP = mcolors.ListedColormap(['lightgray', 'blue', 'red', 'green', 'purple'])