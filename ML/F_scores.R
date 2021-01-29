### Author: Yile Wang
### Titile: A simple function to calculate Fisher-Scores for feature selection and ML

F_Scores <- function(data, n1, n2){
  ### the F-Score Analysis is a statistical techniques for feature selection.
  ### It helps us to maximize the distance between two categories.
  ### There are three parameters in this function:
  ###   data: data table with all the features in the columns and observation in the rows.
  ###   n1:   the sample number of the first category.
  ###   n2:   the sample number of the second category.
  
  ### Reference: Arunasakthi, K., KamatchiPriya, L., & Askerunisa, A. (2014, March). 
  ###            Fisher score dimensionality reduction for SVM classification. 
  ###            In International Conference on Innovations in Engineering and Technology (ICIET14) (pp. 1900-1904).
  data = as.matrix(data)
  f_scores = matrix(0, ncol = length(data[1,]))
  f_up = matrix(0, nrow = length(data[1,]))
  f_down_1 = matrix(0, nrow = length(data[1,]))
  f_down_2 = matrix(0, nrow = length(data[1,]))
  f_down_group_1 = matrix(0, nrow = n1)
  f_down_group_2 = matrix(0, nrow = n2)
  
  for (j in 1:length(data[1,])){
    f_up[j] = (mean(data[0:10, j]) - mean(data[,j]))^2 + (mean(data[11:23, j]) - mean(data[,j]))^2
    for (i in 1:n1){
      f_down_group_1[i] = (data[i,j] - mean(data[0:10, j]))^2
    }
    for (p in 1:n2){
      f_down_group_2[p] = (data[10+p,j] - mean(data[11:23, j]))^2
    }
    f_down_1[j] = (1/(n1 -1)) * sum(f_down_group_1)
    f_down_2[j] = (1/(n2 -1)) * sum(f_down_group_2)
    f_scores[j] = f_up[j] / (f_down_1[j] + f_down_2[j])
  }
  colnames(f_scores) <- colnames(data)
  f_scores
}
