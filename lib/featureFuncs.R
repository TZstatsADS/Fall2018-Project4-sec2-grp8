n_grams_vocabulary <- function(n, data) {
  # this function build n-gram data
  
  options(mc.cores=1)
  # Builds n-gram tokenizer 
  tk <- function(x) NGramTokenizer(x, Weka_control(min = n, max = n))
  # Create matrix
  ngrams_matrix <- TermDocumentMatrix(data, control=list(tokenize=tk))
  # make matrix for easy view
  ngrams_matrix <- as.matrix(rollup(ngrams_matrix, 2, na.rm=TRUE, FUN=sum))
  ngrams_matrix <- data.frame(word=rownames(ngrams_matrix), freq=ngrams_matrix[,1])
  # find 20 most frequent n-grams in the matrix
  ngrams_matrix <- ngrams_matrix[order(-ngrams_matrix$freq), ]
  ngrams_matrix$word <- factor(ngrams_matrix$word, as.character(ngrams_matrix$word))
  return(ngrams_matrix)
}

initial_dataset <- function(){
  data_set <- data.frame("error_term" = character(0), 
                         "gt_term" = character(0), 
                         "candidate" = character(0),
                         "feature1" = integer(0),
                         "feature2" = integer(0),
                         "feature3" = integer(0),
                         "feature4" = integer(0),
                         "feature5" = integer(0),
                         "feature6" = integer(0),
                         "file_index" = integer(0),
                         "error_index" = integer(0))
  return(data_set)
  
}



## function to calcualte candidate's exact frequency
freq5 <- function(test, n_gram){
  ifelse(sum(n_gram$word == test) == 0, 0, n_gram[n_gram$word == test, ]$freq)
}

## function to calcualte candidate's relaxd frequency
freq6 <- function(test, ngram){
  test <- correct_pattern(test)
  ifelse(sum(grep(test, ngram$word)) == 0, 0, sum(ngram$freq[grep(test, ngram$word)]))
}

## function to calculate score based on context frequency
context_score <- function(frequency){
  if(max(frequency) == 0){
    return(frequency)
  }else{
    return(frequency/max(frequency))
  } 
}

correct_pattern <- function(single_pattern){
  return(gsub(x = single_pattern, pattern = "\\(", replacement = "\\\\\\(", ignore.case = TRUE))
}