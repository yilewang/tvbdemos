bins_helper <- function(DATA, name = "Variable") {
  data <- as.data.frame(DATA)
  tp <- quantile(as.numeric(data$DATA),seq(0,1,1/3))
  ac = as.data.frame(table(data))
  if (tp[3] < tp[4]){
    if (ac[1,"Freq"] > 3){low <- which(data< tp[2])
    high <- which(data > tp[3])
    medium <- which(data  >= tp[2] & data <=tp[3])
    data[low,] <- 0
    data[medium,] <- 1
    data[high,] <-2
    }else{ low <- which(data <= tp[2])
    high <- which(data > tp[3])
    medium <- which(data > tp[2] & data <=tp[3])
    data[low,] <- 0
    data[medium,] <- 1
    data[high,] <-2}
  }else{low <-which(data < tp[2])
  high <- which(data >= tp[3])
  medium <- which(data >= tp[2] & data <tp[3]) 
  data[low,] <- 0
  data[medium,] <- 1
  data[high,] <-2}
  a.c = as.data.frame(table(data))
  colnames(a.c) <- c("Value","Freq")
  rownames(a.c) <- c("Level_1", "Level_2", "Level_3")
  #print(a.c)
  spearman.col.score <- cor(DATA, as.numeric(data$DATA), 
                            method = "spearman")
  cat(name, "spearman r:", spearman.col.score, "\n")
  return(data)
}