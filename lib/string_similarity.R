string_similiarity <- function(w_e, candidate_set,a.1,a.2,a.3) {
  # this function is used to calculate feature 2 score
  
  library("qualV")
  
  # First, break each candidate string and the error into single letter
  w_c_list <- strsplit(candidate_set, split = "")
  w_e <- unlist(strsplit(w_e, split = ""))
  
  ## nlcs
  lcs_len <- vector()
  w_c_len <- vector()
  for (i in 1:length(w_c_list)) {
    lcs_len[i] <- lapply(w_c_list, LCS, w_e)[[i]]$LLCS
    w_c_len[i] <- length(w_c_list[[i]])
  }
  nlcs <- (2 * lcs_len^2)/(w_c_len + length(w_e))
  
  consecutive <- function(vector = w_e, list = w_c_list, n = 1) {
    len <- vector()
    # i stands for i_th word in the candidate list 
    for (i in 1:length(list)) {
      
      # recursive factor, for counting the common length
      r <- 0
      
      # j stands for the j_th letter in the i_th word
      for (j in n:min(length(vector), length(list[[i]]))) {
        
        if (vector[j] == list[[i]][j]) {
          r <- r + 1
        }
        else {
          break
        }
      }
      len[i] <- r
    }
    return(len)
  }
  
  # nmnlcs_1
  
  nmnlcs_1 <- consecutive(n = 1)/(w_c_len + length(w_e))
  
  # nmnlcs_n
  
  #n <- 2
  #nmnlcs_n <- consecutive(n = 2)/(w_c_len + length(w_e))
  
  # nmnlcs_z
  
  # First, reverse every letter in each word
  w_e_rev <- rev(w_e)
  w_c_rev_list <- list()
  for (i in 1:length(w_c_list)) {
    w_c_rev_list[[i]] <- rev(w_c_list[[i]])
  }
  
  nmnlcs_z <- consecutive(vector = w_e_rev, list = w_c_rev_list, n = 1)/(w_c_len + length(w_e))
  
  # Not sure how to choose alphas, giving them a defult 1/4
  a_1 <- a.1
  a_2 <- a.2
  a_3 <- a.3
  score <- a_1 * nlcs + a_2 * nmnlcs_1 + a_3 * nmnlcs_z
  return(score)
}