n_grams_vocabulary <- function(n, data) {
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

#unigram <- n_grams_vocabulary(n=1, data=ground_truth_Corpus)
#three_gram <- n_grams_vocabulary(n=3, data=ground_truth_Corpus)
#save(unigram, file=paste0("../output/unigram.RData"))
#save(three_gram, file=paste0("../output/three_gram.RData"))
