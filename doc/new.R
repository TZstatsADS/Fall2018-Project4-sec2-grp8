if (!require("devtools")) install.packages("devtools")
if (!require("pacman")) {
  ## devtools is required
  library(devtools)
  install_github("trinker/pacman")
}

pacman::p_load(knitr, readr, stringr, tesseract, vecsets)
setwd("C:/Users/Oded/Desktop/Fall2018-Project4-sec2--sec2proj4_grp8/doc")
source('../lib/ifCleanToken.R')
file_name_vec <- list.files("../data/ground_truth") #100 files in total

n_file = length(file_name_vec)
tesseract_vec_all = list() # each element is a vector of words for each text file
tesseract_lines_all = list() # each element is a list of lines for each text file
gt_vec_all = list() # each element is a vector of words for each text file
gt_lines_all = list() # each element is a list of lines for each text file
len_check = rep(NA, 100)
len_check2 = rep(NA, 100)

## check if each tesseract file has the same number of length with its corresponding ground truth

for(i in 1:n_file){
  ## i represents that this is the i-th file we are dealing with
  current_file_name <- sub(".txt","",file_name_vec[i])
  
  ## read the ground truth text, save it by lines & vectorize it
  current_ground_truth_txt = readLines(paste("../data/ground_truth/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## read the tesseract text, save it by lines & vectorize it
  current_tesseract_txt <- readLines(paste("../data/tesseract/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## check if each tesseract file has the same number of length with its corresponding ground truth
  len_check[i] = length(current_ground_truth_txt) == length(current_tesseract_txt)
  ## check if all ground truth are not shorter than its Tesseract
  len_check2[i] = length(current_ground_truth_txt) >= length(current_tesseract_txt)
}

# there exist pairs that do not have same number of lines:
which(!len_check) 
# all ground truth files have at least same number of lines compared with corresponding Tesseract files:
which(!len_check2) 
n_file-sum(len_check)

## check if each tesseract file has the same number of length with its corresponding ground truth

for(i in 1:n_file){
  ## i represents that this is the i-th file we are dealing with
  current_file_name <- sub(".txt","",file_name_vec[i])
  
  ## read the ground truth text, save it by lines & vectorize it
  current_ground_truth_txt = readLines(paste("../data/ground_truth/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## read the tesseract text, save it by lines & vectorize it
  current_tesseract_txt <- readLines(paste("../data/tesseract/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## check if each tesseract file has the same number of length with its corresponding ground truth
  len_check[i] = length(current_ground_truth_txt) == length(current_tesseract_txt)
  len_check2[i] = length(current_ground_truth_txt) >= length(current_tesseract_txt)
}

# there exist pairs that do not have same number of lines:
which(!len_check) 
# all ground truth files have at least same number of lines compared with corresponding Tesseract files:
which(!len_check2) 
100-sum(len_check)

for(i in 1:n_file){
  ## i represents that this is the i-th file we are dealing with
  current_file_name <- sub(".txt","",file_name_vec[i])
  
  ## read the ground truth text, save it by lines & vectorize it
  current_ground_truth_txt = readLines(paste("../data/ground_truth/",current_file_name,".txt",sep=""), warn=FALSE)
  gt_lines_all[[i]] = current_ground_truth_txt
  gt_vec_all[[i]] <- str_split(paste(current_ground_truth_txt, collapse = " ")," ")[[1]]
  
  ## read the tesseract text, save it by lines & vectorize it
  current_tesseract_txt <- readLines(paste("../data/tesseract/",current_file_name,".txt",sep=""), warn=FALSE)
  tesseract_lines_all[[i]] = current_tesseract_txt
  clean_tesseract_txt <- paste(current_tesseract_txt, collapse = " ")
  tesseract_vec_all[[i]] = str_split(clean_tesseract_txt," ")[[1]]
  
  ## check if each tesseract file has the same number of length with its corresponding ground truth
  len_check[i] = length(tesseract_lines_all[[i]]) == length(gt_lines_all[[i]])
}

same_na = rep(NA, n_file)
for(i in 1:n_file){
  ## i represents that this is the i-th file we are dealing with
  current_file_name <- sub(".txt","",file_name_vec[i])
  
  ## read the ground truth text
  current_ground_truth_txt = readLines(paste("../data/ground_truth_trimmed/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## read the tesseract text
  current_tesseract_txt <- readLines(paste("../data/tesseract/",current_file_name,".txt",sep=""), warn=FALSE)
  
  ## only keep the line pairs that have the same number of words
  n_line = length(current_ground_truth_txt)
  for (j in 1:n_line){
    same_len_logi = length(str_split(current_ground_truth_txt[j], " ")[[1]]) == 
      length(str_split(current_tesseract_txt[j], " ")[[1]])
    if(!same_len_logi){
      current_ground_truth_txt[j] = NA
      current_tesseract_txt[j] = NA
    }
  }
  na_logi1 = is.na(current_ground_truth_txt)
  na_logi2 = is.na(current_tesseract_txt)
  same_na[i] = all(na_logi1 == na_logi2) # check if all the lines are assigned accordingly
  
  ## save and vectorized cleaned text
  gt_lines_all[[i]] = current_ground_truth_txt[!na_logi1]
  gt_vec_all[[i]] <- str_split(paste(gt_lines_all[[i]], collapse = " ")," ")[[1]]
  tesseract_lines_all[[i]] = current_tesseract_txt[!na_logi2]
  tesseract_vec_all[[i]] = str_split(paste(tesseract_lines_all[[i]], collapse = " ")," ")[[1]]
  
  ## re-check if each tesseract file has the same number of length with its corresponding ground truth
  len_check[i] = length(tesseract_lines_all[[i]]) == length(gt_lines_all[[i]])
}
## recheck if lines are removed correctly
all(same_na)
## re-check if each tesseract file has the same number of length with its corresponding ground truth
all(len_check)

## recheck if all the words in a pair of files can be mapped 1 to 1 now
map11 = rep(NA,n_file)
for(i in 1:n_file){
  map11[i] = length(tesseract_vec_all[[i]]) == length(gt_vec_all[[i]])
}
all(map11)

MatchDetect = list()
for(i in 1:n_file){
  tesseract_vec <- tesseract_vec_all[[i]]
  tesseract_if_clean <- unlist(lapply(tesseract_vec,ifCleanToken)) # source code of ifCleanToken in in lib folder
  mat = cbind(tesseract_vec_all[[i]], gt_vec_all[[i]],tesseract_if_clean)
  df = data.frame(mat)
  colnames(df) = c("Tesseract", "GroundTruth", "Detect")
  MatchDetect[[i]] = df
}

save(MatchDetect, file=paste0("../output/MatchDetect.RData"))

# setwd("C:/Users/Oded/Desktop/Fall2018-Project4-sec2--sec2proj4_grp8/output")
load("MatchDetect.RData")

###############
# Oded's part #
###############

error <- list()
for(i in 1:100){
  error[[i]] <- tesseract_vec_all[[i]][MatchDetect[[i]]$Detect==FALSE]
}

error.words <- unlist(error)
lexicon <- unlist(gt_vec_all)

err.1 <- list()
for(i in 1:length(error.words)){
  err.1[[i]] <- adist(error.words[i],lexicon)
}

score.1 <- function(delta){
  score.1 <- 1-(err/delta)
  return(score.1)
}
# we need to cross validate for different values of delta

# creating groups of words
group2 <- list()
for(j in 1:5){
  group2[[j]] <- error[which(as.numeric(substr(file_name_vec,6,6))==j)]
}

group3 <- list()
for(j in 1:5){
  group3[[j]] <- group3[which(as.numeric(substr(file_name_vec,6,6))==j)]
}

# for an error in group i, if the candidate word from the whole lexicon exists in the words from group i or not:
# these are the scores for each one candidate (basically has nothing to do with the error word, only need to extract according to the text group checked):
lex <- matrix(NA, 5,length(lexicon))
for(i in 1:length(lexicon)){
  for(j in 1:5){
    lex[[j,i]] <- ifelse(lexicon[i]%in%unlist(group3[[j]]),1,0)
  }
}