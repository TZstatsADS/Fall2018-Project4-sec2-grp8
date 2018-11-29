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
2. Error Detection, use rule based method from [paper D1](doc/paper/D-1.pdf).

3. Error Correction, first calculate 6 features scoring for each candidate based on [assigned paper C2](doc/paper/C-2.pdf), then use AdaBoost.R2 model on top of decision trees with 0-1 loss function. Generate a prediction of top 3 best results as correction.
4.Evaluated OCR performance by calculating precision and recall for both word-level and character-level.

	
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
