# Project: OCR (Optical Character Recognition) 

### Data folder

The data directory contains data used in the analysis. This is treated as read only; 

In this project, there are three subfolders -- 

Firstly, ground_truth and tesseract. Each folder contains 100 text files with same file names correspondingly.

And there are another folder called ground_truth_trimmed, which contains preprocessed ground truth. During the preprocess phase, we delete rows with characters but can’t be recognized in Tesseract; Then delete rows in ground truth and tesseract which character number don’t match. 

We use ground_truth_trimmed as our input in the following process.

