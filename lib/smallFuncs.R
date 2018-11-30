compareFunc = function(df){
  # this function compare if the word pair (tesseract and ground truth) is same or not
  df$Actual = df$Tesseract == df$GroundTruth
  return(df)
}

recallFunc = function(nums){
  # this function calculate the recall
  text = nums[1]
  gt = nums[2]
  return(min(text,gt)/max(text,gt))
}
precisionFunc = function(nums){
  # this function calculate the precision
  text = nums[1]
  gt = nums[2]
  return(min(text,gt)/text)
}