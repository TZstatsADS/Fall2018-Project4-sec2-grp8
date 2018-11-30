##############################
## Garbage detection
## Ref: first three rules in the paper
##      'On Retrieving Legal Files: Shortening Documents and Weeding Out Garbage'
## Input: one word -- token
## Output: bool -- if the token is clean or not
##############################

detect3 = function(aString){
  # this function are used for rule 3
  flg = 0
  chars = str_split(aString,'')
  chars = chars[[1]]
  i = 1
  while(flg == 0 & i <= (nchar(aString)-2)){
    if(chars[i] == chars[i+1] & chars[i+1] == chars[i+2]) flg = 1
    i = i+1
  }
  return(flg)
}

detectVC = function(aString){
  # this function are used for rule 7
  flg2 = 0
  chars = str_split(aString,'')
  chars = chars[[1]]
  i = 1
  vows = c('a','e','i','o','u','A','E','I','O','U')
  consos = c('b','c','d','f','g','h','j','k','l','m','n',
             'p','q','r','s','t','v','w','x','y','z',
             'B','C','D','F','G','H','J','K','L','M',
             'N','P','Q','R','S','T','V','W','X','Y','Z')
  # detect 4 vowels in a row
  while(flg2 == 0 & i <= (nchar(aString)-3)){
    if(any(chars[i]==vows)
       & any(chars[i+1]==vows)
       & any(chars[i+2]==vows)
       & any(chars[i+3]==vows)) flg2 = 1
    i = i + 1
  }
  # detect 5 consonants in a row
  i = 1
  while(flg2 == 0 & i <= (nchar(aString)-4)){
    if(any(chars[i]==consos)
       & any(chars[i+1]==consos)
       & any(chars[i+2]==consos)
       & any(chars[i+3]==consos)
       & any(chars[i+4]==consos)) flg2 = 1
    i = i + 1
  }
  return(flg2)
}



ifCleanToken <- function(cur_token){
  # this function decide whether a token is garbage
  # returns FALSE if it is a garbage
  now <- 1
  if_clean <- TRUE
  
  ## in order to accelerate the computation, conduct ealy stopping
  rule_list <- c("str_count(cur_token, pattern = '[A-Za-z0-9]') <= 0.5*nchar(cur_token)", # If the number of punctuation characters in a string is greater than the number of alphanumeric characters, it is garbage
                 "length(unique(strsplit(gsub('[A-Za-z0-9]','',substr(cur_token, 2, nchar(cur_token)-1)),'')[[1]]))>1", #Ignoring the first and last characters in a string, if there are two or more different punctuation characters in thestring, it is garbage
                 "nchar(cur_token)>20", #A string composed of more than 20 symbols is garbage
                 "str_count(cur_token, pattern='[A-Z]')>str_count(cur_token, pattern='[a-z]') & str_count(cur_token, pattern='[A-Z]')<nchar(cur_token)", # rule 5
                 "str_count(cur_token,pattern='[A-Za-z]')== nchar(cur_token) &
                 (9*str_count(cur_token,pattern='[B-DF-HJ-NP-TV-Zb-df-hj-np-tv-z]') > 8*nchar(cur_token) |
                 9*str_count(cur_token,pattern='[AEIOUaeiou]') > 8*nchar(cur_token))", # rule 6
                 "any(grep('[a-z]',strsplit(cur_token,'')[[1]])==1)&any(grep('[a-z]',strsplit(cur_token,'')[[1]])==nchar(cur_token))&(str_count(cur_token,pattern='[A-Z]')>0)", # rule 8
                 "detect3(cur_token)==1", # rule 3
                 "detectVC(cur_token)==1" # rule 7
                 )
  while((if_clean == TRUE)&now<=length(rule_list)){
    if(eval(parse(text = rule_list[now]))){
      if_clean <- FALSE
    }
    
    now <- now + 1
  }
  return(if_clean)

}