# Step 1 - Load library and source code

if (!require("devtools")) {
  install.packages("devtools") 
}

if (!require("pacman")) {
  library(devtools)
  install_github("trinker/pacman")
}

pacman::p_load(knitr, readr, stringr, tesseract, vecsets)

source('~/Desktop/ifCleanToken.R')

file_name_vec <- list.files("~/Desktop/data/ground_truth")

# Step 2 - read the files and conduct Tesseract OCR



# Step 3 - Error detection

# check to see if an input string is a valid dictionary word or if its n-grams are all legal.

# read ground truth text into 1 list

n_file <- length(file_name_vec)
tesseract_vec_all <- list() # each element is a vector of words for each text file
tesseract_lines_all <- list() # each element is a list of lines for each text file
gt_vec_all <- list() # each element is a vector of words for each text file
gt_lines_all <- list() # each element is a list of lines for each text file
len_check <- rep(NA, 100)
len_check2 <- rep(NA, 100)

for (i in 1:n_file) {
  
  ## i represents that this is the i-th file we are dealing with
  current_file_name <- sub(".txt", "", file_name_vec[i])
  
  ## read the ground truth text, save it by lines & vectorize it
  current_ground_truth_txt <- readLines(paste("~/Desktop/data/ground_truth/", 
                                              current_file_name, ".txt", sep = ""), warn = FALSE)
  gt_lines_all[[i]] <- current_ground_truth_txt
  gt_vec_all[[i]] <- str_split(paste(current_ground_truth_txt, collapse = " "), " ")[[1]]
  
  ## read the tesseract text, save it by lines & vectorize it
  current_tesseract_txt <- readLines(paste("~/Desktop/data/tesseract/",
                                           current_file_name, ".txt", sep = ""), warn = FALSE)
  tesseract_lines_all[[i]] <- current_tesseract_txt
  clean_tesseract_txt <- paste(current_tesseract_txt, collapse = " ")
  tesseract_vec_all[[i]] <- str_split(clean_tesseract_txt, " ")[[1]]
  
  ## check if each tesseract file has the same number of length with its corresponding ground truth
  len_check[i] <- length(tesseract_lines_all[[i]]) == length(gt_lines_all[[i]])
  len_check2[i] <- length(current_ground_truth_txt) >= length(current_tesseract_txt)
  
}

# there exist pairs that do not have same number of lines:
which(!len_check)
# all ground truth files have at least same number of lines compared with corresponding Tesseract files:
which(!len_check2)
100 - sum(len_check)

dFunc <- function(i) {
  
  ## detect tesseract word error
  tesseract_vec <- tesseract_vec_all[[i]]
  tesseract_if_clean <- unlist(lapply(tesseract_vec, ifCleanToken))
  
  return(tesseract_if_clean)
  
}

DetectOutput <- lapply(1:length(file_name_vec), dFunc)
save(DetectOutput, file = paste0("~/Desktop/output/DetectOutput.RData"))


# Step 4 - Error correction

load("../output/DetectOutput.RData")

library('stringdist')
theta <- 3 # distance threshold

## read the ground truth text

clean_ground_truth_txt <- paste(current_ground_truth_txt, collapse = " ")
ground_truth_vec <- str_split(clean_ground_truth_txt," ")[[1]] 

## read the tesseract text

clean_tesseract_txt <- paste(current_tesseract_txt, collapse = " ")
tesseract_vec <- str_split(clean_tesseract_txt," ")[[1]] #1124 tokens

cFunc <- function(i) {
  
  ## select error terms from tesseract_vec by DetectOutput
  error_term <- tesseract_vec[DetectOutput[[i]] == FALSE]
  
  ## for each error
  for (j in 1:length(error_term)) {
    w_e <- error_term[j]
    ## create a candidate set for each error
    k <- sapply(ground_truth_vec, stringdist, b = w_e, method = "lv") # by Levenshtein distance
    candidate_set <- ground_truth_vec[k <= theta]
    save(candidate_set, file = paste0("../output/DetectOutput.RData"))
    
    ## feature scoring
    
    ### String similarity
    
    # Haven't done it yet...
    
    ### Language popularity
    candidate_set <- tolower(candidate_set)
    
    # numerator
    candidate_freq <- sort(table(candidate_set), decreasing = T)/length(candidate_set)
    
    # denominator
    max_freq <- sort(table(candidate_set), decreasing = T)[1]/length(candidate_set)
    
    # score
    bbb[, 2]/max_freq
  }
  
}




# Step 5 - Performance measure
```{r}
ground_truth_vec <- str_split(paste(current_ground_truth_txt, collapse = " ")," ")[[1]] #1078
old_intersect_vec <- vecsets::vintersect(tolower(ground_truth_vec), tolower(tesseract_vec)) #607
new_intersect_vec <- vecsets::vintersect(tolower(ground_truth_vec), tolower(tesseract_delete_error_vec)) #600

OCR_performance_table <- data.frame("Tesseract" = rep(NA,4),
                                    "Tesseract_with_postprocessing" = rep(NA,4))
row.names(OCR_performance_table) <- c("word_wise_recall","word_wise_precision",
                                      "character_wise_recall","character_wise_precision")
OCR_performance_table["word_wise_recall","Tesseract"] <- length(old_intersect_vec)/length(ground_truth_vec)
OCR_performance_table["word_wise_precision","Tesseract"] <- length(old_intersect_vec)/length(tesseract_vec)
OCR_performance_table["word_wise_recall","Tesseract_with_postprocessing"] <- length(new_intersect_vec)/length(ground_truth_vec)
OCR_performance_table["word_wise_precision","Tesseract_with_postprocessing"] <- length(new_intersect_vec)/length(tesseract_delete_error_vec)
kable(OCR_performance_table, caption="Summary of OCR performance")
```