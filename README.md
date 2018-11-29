# Project: OCR (Optical Character Recognition) 

![image](figs/intro.png)

### [Full Project Description](doc/project4_desc.md)

Term: Fall 2018

+ Team #8
+ Team members
	+ Bai, Ruoxi   rb3313
	+ Loewenstein, Oded orl2108
	+ Yan, Jiaming   jy2882
	+ Zhong, Qingyang   qz2317
	+ Zhu, Siyu   sz2716

+ Project summary: In this project, we created an OCR post-processing procedure to enhance Tesseract OCR output. 

And here is our steps:
1. Preprocess the data, manually trimmed ground truth since there are 13 pairs of Tesseract and ground truth files that do not have the same number of lines. 
2. Error Detection, use rule based method from [paper D1](doc/paper/D-1.pdf)
Locate the corresponding error words in ground truth dataset.
if the number of words in corresponding row (between tesseract and ground_truth) are equal, locate the ground truth word by indexing directly
if the number of words in corresponding row are not equal, extract previous and following 2 words of the error word (total of 5 index), and apply string-distance function (stringdist) to locate the most likely ground truth word.
Select possible Candidates for errors, calculate fetures scoring for each candidate; label candidate with 1 if it equals to ground truth, else 0.

Performed Adaboost.R2 to predict the top 3 best matching results to replace all error words. C-2: Statistical Learning for OCR Text Correction 
	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
