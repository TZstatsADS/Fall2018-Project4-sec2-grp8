# Project: OCR (Optical Character Recognition) 

![image](figs/intro.png)

### [Full Project Description](doc/project4_desc.md)

Term: Fall 2018

+ Team #8
+ Team members
	+ Bai, Ruoxi   rb3313
	+ Loewenstein, Oded orl2108
	+ Yan, Jiaming   jy2882
	+ Zhong, Qingyang   qz2317  (presenter)
	+ Zhu, Siyu   sz2716

+ Project summary: In this project, we created an OCR post-processing procedure to enhance Tesseract OCR output. 

And here is our steps:
1. Preprocess the data, manually trimmed ground truth since there are 13 pairs of Tesseract and ground truth files that do not have the same number of lines. 
2. Error Detection, use rule based method from [paper D1](doc/paper/D-1.pdf).
![image](figs/rules.png)
3. Error Correction, first calculate 6 features scoring for each candidate based on assigned [paper C2](doc/paper/C-2.pdf), then use AdaBoost.R2 model on top of decision trees with 0-1 loss function. Generate a prediction of top 3 best results as correction.
![image](figs/features.png)
4.Evaluated OCR performance by calculating precision and recall for both word-level and character-level.

	
**Contribution statement**: 
	+ Bai, Ruoxi: Data preprocessing; Error Detection; Regression Model; Evaluation;
	+ Loewenstein, Oded: Feature: Levenshtein edit distance & feature: Lexicon existance; Tune parameters from regression model and visualization.
	+ Yan, Jiaming: Feature: String similarity & feature: Language popularity
	+ Zhong, Qingyang: Data preprocessing; Error Detection; Evaluation; Combine all codes together; README; Presentation
	+ Zhu, Siyu: Candidate search; N-gram function; Feature: Exact-context popularity & feature: Relaxed-context popularity; Combine 6 features together.

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
