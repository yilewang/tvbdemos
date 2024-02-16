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
  # get length of observation
  num_row <- nrow(a.c)
  rownames(a.c) <- c("Level_1", "Level_2", "Level_3")[1:num_row]
  #print(a.c)
  spearman.col.score <- cor(DATA, as.numeric(data$DATA), 
                            method = "spearman")
  cat(name, "spearman r:", spearman.col.score, "\n")
  return(data)
}

plot.scree <- function(eigs, p.vals){
  PlotScree(ev = eigs,
            p.ev = p.vals,
            plotKaiser = TRUE,
            title = "Explained Variance per Dimension")
}

plot.permutation <- function(eigs.perm, eigs, 
                             para1 = 5,  para2 = 20, 
                             Dim = 1){
  zeDim = Dim
  pH <- prettyHist(
    distribution = eigs.perm[,zeDim], 
    observed = eigs[zeDim], 
    xlim = c(0,para1), # needs to be set by hand
    breaks = para2,
    border = "gray", 
    main = paste0("Permutation Test for Eigenvalue ",zeDim),
    xlab = paste0("Eigenvalue ",zeDim), 
    ylab = "", 
    counts = FALSE, 
    cutoffs = c( 0.975))
}


plot.fs <- function(DESIGN, fs, eigs, 
                    tau, d = 1, mode="CI",
                    method = " ")
{
  fs <- as.matrix(fs)
  # GETMEANS
  fm.tmp <- aggregate(fs, list(DESIGN), mean)
  fm <- fm.tmp[,2:ncol(fm.tmp)]
  rownames(fm) <- fm.tmp[,1]
  tau <- round(tau)
  color.dot <- as.matrix(DESIGN)
  na.de <- as.matrix(levels(DESIGN))
  num.de <- length(na.de)
  index <- c("#66CDAA","#4682B4","#AB63FA","#FFA15A")
  # index <- prettyGraphsColorSelection(n.colors = 4)

  for (i in 1: num.de){
    color.dot[which(color.dot == na.de[i])] <- index[i]
  }
  color.dot <- as.matrix(color.dot)
  rownames(color.dot) <- DESIGN
  fs.plot <- createFactorMap(fs, # data
                             title = paste0("Factor Scores_",
                                            method), 
                             alpha.points = 0.5,
                             axis1 = d, axis2 = (d+1), 
                             pch = 19, 
                             cex = 2,
                             text.cex = 2.5, 
                             display.labels = TRUE,
                             col.points = color.dot, 
                             col.labels =  color.dot
  )
  fs.label <- createxyLabels.gen(d,(d+1),
                                 lambda = eigs,
                                 tau = tau,
                                 axisName = "Component "
  )
  ind <- c(1:num.de)
  for (i in 1:num.de){
    inde <- match(rownames(color.dot), 
                  sort(rownames(fm)))
    ind[i] <- which(inde == i)[1]
  }
  grp.ind <- ind
  rownames(fm[sort(rownames(fm)),]) <- sub("[[:punct:]]","",
                                           rownames(fm[sort(rownames(fm)),]))
  
  graphs.means <- PTCA4CATA:: createFactorMap(fm[sort(rownames(fm)),],
                                              axis1 = d, axis2 =(d+1), 
                                              constraints = fs.plot$constraints,
                                              col.points = color.dot[grp.ind],
                                              col.labels = color.dot[grp.ind],
                                              alpha.points = 0.9)
  
  BootCube <- PTCA4CATA::Boot4Mean(fs, 
                                   design = as.factor(DESIGN), 
                                   niter = 100)
  
  dimnames(BootCube$BootCube)[[2]] <- paste0("dim ", 1:dim(BootCube$BootCube)[[2]])
  
  boot.elli <- MakeCIEllipses(data =
                                BootCube$BootCube[,d:(d+1),][sort(rownames(BootCube$BootCube[,d:(d+1),])),,],
                              names.of.factors = 
                                c(paste0("Dimension ", d),paste0("Dimension ", 
                                                                 (d+1))),
                              col = color.dot[grp.ind],
                              alpha.line = 0.3,
                              alpha.ellipse = 0.3
  )
  
  # with Hull
  colnames(fs) <- paste0('Dimension ', 1:ncol(fs))
  # getting the color correct: an ugly trick
  #col.groups <- as.data.frame(col.groups)
  DESIGN <- factor(DESIGN, levels = DESIGN[grp.ind])
  GraphHull <- PTCA4CATA::MakeToleranceIntervals(fs, 
                                                 axis1 = d, 
                                                 axis2 = (d+1),
                                                 design = DESIGN,
                                                 col = color.dot[grp.ind],
                                                 names.of.factors =  c(paste0("Dim ", d),
                                                                       paste0("Dim 2", (d+1))),
                                                 p.level = 1.00)
  
  if (mode == "hull"){
    factor.map <- fs.plot$zeMap_background +
      GraphHull + 
      fs.plot$zeMap_dots + 
      fs.plot$zeMap_text + 
      fs.label +  
      graphs.means$zeMap_dots + 
      graphs.means$zeMap_text}
  if (mode == "CI"){
    factor.map <- fs.plot$zeMap_background +
      boot.elli + 
      fs.plot$zeMap_dots + 
      fs.plot$zeMap_text + 
      fs.label +  
      graphs.means$zeMap_dots + 
      graphs.means$zeMap_text}
  factor.map
}


plot.loading <- function(data, col=NULL, fs, eigs, tau, d=1){
  if (is.null(col)){
    col <- prettyGraphsColorSelection(n.colors = ncol(data))
  }
  cor.loading <- cor(data, fs)
  rownames(cor.loading) <- rownames(cor.loading)
  fi.labels <- createxyLabels.gen(d,(d+1),
                                  lambda = eigs,
                                  tau =  round(tau),
                                  axisName = "Component "
  )
  loading.plot <- createFactorMap(cor.loading,
                                  axis1 = d, 
                                  axis2 = (d+1),
                                  constraints = list(minx = -1, miny = -1,
                                                     maxx = 1, maxy = 1),
                                  col.points = col,
                                  col.labels = col)
  LoadingMapWithCircles <-  loading.plot$zeMap_background + 
    loading.plot$zeMap_dots +
    addArrows(cor.loading[,d:(d+1)], color = col) +
    addCircleOfCor() +
    loading.plot$zeMap_text +  
    fi.labels
  LoadingMapWithCircles
}

plot.cfs <- function(fj, eigs, 
                     tau, d = 1, 
                     col = NULL, 
                     method = " ", 
                     colrow = "row")
{
  if(colrow == "row"){
    cr <- nrow(fj)
  }
  if(colrow == "col"){
    cr <- ncol(fj)
  }
  if(is.null(col)){
    col <- prettyGraphs::prettyGraphsColorSelection(cr)
  }
  fj.labels <- createxyLabels.gen(d,(d+1),
                                  lambda = eigs,
                                  tau = round(tau),
                                  axisName = "Component "
  )
  fj.plot <- createFactorMap(fj, # data
                             title = paste0("Factor Scores", method),
                             axis1 = d, 
                             axis2 = (d+1), 
                             pch = 19, 
                             cex = 2, 
                             text.cex = 3, 
                             col.points = col, 
                             col.labels = col 
  )
  column.factor.map <- fj.plot$zeMap_background + 
    fj.plot$zeMap_dots + 
    fj.plot$zeMap_text + 
    fj.labels
  column.factor.map
}

plot.cb <- function(cj, fj, col = NULL, 
                    boot.ratios, signifOnly = FALSE, 
                    fig = 2, horizontal = FALSE, 
                    colrow = "col", fontsize = 3)
{
  if (colrow == "col"){
    cr <- ncol(cj)
  }
  if (colrow == "row"){
    cr <- nrow(cj)
  }
  # Contribution Plot
  ### plot contributions for component 1
  if (is.null(col)){
    col <- prettyGraphs::prettyGraphsColorSelection(cr)
  }
  signed.ctrJ <- cj * sign(fj)
  laDim = 1
  ctrJ.1 <- PrettyBarPlot2(signed.ctrJ[,laDim],
                           threshold = 1 / NROW(signed.ctrJ),
                           font.size = fontsize,
                           signifOnly = signifOnly,
                           horizontal = horizontal,
                           color4bar = col, # we need hex code
                           main = 'Variable Contributions (Signed)',
                           ylab = paste0('Contributions Barplot',
                                         laDim),
                           ylim = c(1.2*min(signed.ctrJ), 
                                    1.2*max(signed.ctrJ))
  ) + ggtitle("Contribution",subtitle = paste0('Component ', laDim))
  
  ### plot contributions for component 2
  laDim =2
  ctrJ.2 <- PrettyBarPlot2(signed.ctrJ[,laDim],
                           threshold = 1 / NROW(signed.ctrJ),
                           font.size = fontsize,
                           color4bar = col, # we need hex code
                           signifOnly =signifOnly,
                           horizontal = horizontal,
                           main = 'Variable Contributions (Signed)',
                           ylab = paste0('Contributions Barplot',laDim),
                           ylim = c(1.2*min(signed.ctrJ),1.2*max(signed.ctrJ))
  )+ ggtitle("",subtitle = paste0('Component ', laDim))
  laDim =3
  ctrJ.3 <- PrettyBarPlot2(signed.ctrJ[,laDim],
                           threshold = 1 / NROW(signed.ctrJ),
                           font.size = fontsize,
                           color4bar = col, # we need hex code
                           signifOnly = signifOnly,                             
                           horizontal = horizontal,
                           main = 'Variable Contributions (Signed)',
                           ylab = paste0('Contributions Barplot',laDim),
                           ylim = c(1.2*min(signed.ctrJ), 
                                    1.2*max(signed.ctrJ))
  )+ ggtitle("",subtitle = paste0('Component ', laDim))
  
  
  
  ### Bootstrap of columns vectors
  BR <- boot.ratios
  laDim = 1
  
  # Plot the bootstrap ratios for Dimension 1
  ba001.BR1 <- PrettyBarPlot2(BR[,laDim],
                              threshold = 2,
                              font.size = fontsize,
                              signifOnly = signifOnly,
                              horizontal = horizontal,
                              color4bar = col, # we need hex code
                              ylab = 'Bootstrap ratios',
                              ylim = c(1.2*min(BR[,laDim]), 
                                       1.2*max(BR[,laDim]))
  ) + ggtitle("Bootstrap ratios", 
              subtitle = paste0('Component ', laDim))
  
  # Plot the bootstrap ratios for Dimension 2
  laDim = 2
  ba002.BR2 <- PrettyBarPlot2(BR[,laDim],
                              threshold = 2,
                              font.size = fontsize,
                              signifOnly = signifOnly,                             
                              horizontal = horizontal,
                              color4bar = col, # we need hex code
                              ylab = 'Bootstrap ratios',
                              ylim = c(1.2*min(BR[,laDim]), 
                                       1.2*max(BR[,laDim]))
  ) + ggtitle("",subtitle = paste0('Component ', laDim))
  
  laDim = 3
  ba003.BR3 <- PrettyBarPlot2(BR[,laDim],
                              threshold = 2,
                              font.size = fontsize,
                              signifOnly = signifOnly,                             
                              horizontal = horizontal,
                              color4bar = col,
                              ylab = 'Bootstrap ratios',
                              ylim = c(1.2*min(BR[,laDim]), 
                                       1.2*max(BR[,laDim]))
  ) + ggtitle("",subtitle = paste0('Component ', laDim))
  
  if(fig == 2){
    grid.arrange(
      as.grob(ctrJ.1),
      as.grob(ctrJ.2),
      as.grob(ba001.BR1),
      as.grob(ba002.BR2),
      ncol = 2,nrow = 2,
      top = textGrob("Barplots for variables", 
                     gp = gpar(fontsize = 18, font = 3))
    )
  }
  if(fig==3){
    grid.arrange(
      as.grob(ctrJ.1),
      as.grob(ctrJ.2),
      as.grob(ctrJ.3),
      as.grob(ba001.BR1),
      as.grob(ba002.BR2),
      as.grob(ba003.BR3),
      ncol = 2,nrow = 3,
      top = textGrob("Barplots for variables", 
                     gp = gpar(fontsize = 18, font = 3))
    )
  }
}