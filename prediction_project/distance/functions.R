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
                    colrow = "col", fontsize = 3, d=1)
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
  laDim = d
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
  laDim = d+1
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
  laDim =d+2
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
  laDim = d
  
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
  laDim = d+1
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
  
  laDim = d+2
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

#this function works as a shortcut for users. It's a "recognition engine" to auto perform 1) correct preprocessing and 2) supplemental projection.

#RE: PCA -- supplementary measures should always be center/scaled by active variable constraints
supplementaryRows <- function(SUP.DATA,res){
  SUP.DATA <- as.matrix(SUP.DATA)
  
  output.types <- c("expoOutput","texpoOutput","mexpoOutput")
  data.types <- c("ExPosition.Data","TExPosition.Data","MExPosition.Data")
  mds.types <- c('epMDS')#can add DiSTATIS to this.
  pca.types <- c('epPCA','epGPCA','tepBADA')
  ca.types <- c('epCA','epMCA','tepDICA')	
  
  
  #TEST THIS FURTHER... I SHOULD BE ABLE TO RECOGNZIE TEHSE...	
  if(class(res)[1] %in% output.types){
    indicator <- which(output.types %in% class(res)[1])
    if(names(res)[1] %in% data.types && length(names(res))==2){
      if(output.types[indicator]=="expoOutput"){
        res <- res$ExPosition.Data
      }
      if(output.types[indicator]=="texpoOutput"){
        res <- res$TExPosition.Data
      }
      if(output.types[indicator]=="mexpoOutput"){
        res <- res$MExPosition.Data
      }						
    }else{
      stop(paste("res class type is unknown:",names(res),sep=" "))
    }
  }
  
  if((class(res)[1] %in% c(pca.types))){
    #some trickery happens here... if no res$W is available, it is passed as NULL.
    sup.transform <- pcaSupplementaryRowsPreProcessing(SUP.DATA,center=res$center,scale=res$scale,W=res$W)
    sup.proj <- supplementalProjection(sup.transform,res$fj,res$pdq$Dv)
  }
  
  else if((class(res)[1] %in% c(ca.types))){
    if(res$hellinger){
      #sup.transform <- hellingerSupplementaryRowsPreProcessing(SUP.DATA,center=res$c)
      sup.transform <- hellingerSupplementaryRowsPreProcessing(SUP.DATA,center=res$c)
      sup.proj <- supplementalProjection(sup.transform,f.scores=res$fj,Dv=res$pdq$Dv,symmetric=res$symmetric)
    }else{
      sup.transform <- caSupplementalElementsPreProcessing(SUP.DATA)
      #else
      if((class(res)[1] %in% c('epMCA'))){ ##stupid corrections.
        sup.proj <- supplementalProjection(sup.transform,res$fj,res$pdq$Dv,scale.factor=res$pdq$Dv/res$pdq.uncor$Dv[1:length(res$pdq$Dv)],symmetric=res$symmetric)
      }else{
        sup.proj <- supplementalProjection(sup.transform,res$fj,res$pdq$Dv,symmetric=res$symmetric)
      }
    }
  }
  
  else if((class(res)[1] %in% c(mds.types))){
    sup.transform <- mdsSupplementalElementsPreProcessing(SUP.DATA,res$D,res$M)
    sup.proj <- supplementalProjection(sup.transform,res$fi,res$pdq$Dv)
  }else{
    stop("Unknown class type. Supplementary projection computation must stop.")	
  }
  
  fii <- sup.proj$f.out
  dii <- sup.proj$d.out	
  rii <- sup.proj$r.out
  rownames(fii) <- rownames(dii) <- rownames(rii) <- rownames(SUP.DATA)
  return(list(fii=fii,dii=dii,rii=rii))
}






#tepDICA.inference.battery <- function(DATA, make_data_nominal = FALSE, DESIGN = NULL, make_design_nominal = TRUE, group.masses = NULL, ind.masses = NULL, weights = NULL, hellinger = FALSE, symmetric = TRUE, graphs = TRUE, k = 0, test.iters = 100, critical.value = 2){

tepDICA.inference.battery <- function(DATA, make_data_nominal = FALSE, DESIGN = NULL, make_design_nominal = TRUE, group.masses = NULL, weights = NULL, symmetric = TRUE, graphs = TRUE, k = 0, test.iters = 100, critical.value = 2){	
  ############################	
  ###private functions for now
  #loo.test <- function(DATA, DESIGN, group.masses = NULL, weights = NULL, hellinger = FALSE, symmetric = TRUE,k = k, i){
  loo.test <- function(DATA, DESIGN, group.masses = NULL, weights = NULL, symmetric = TRUE,k = k, i){		
    Xminus1 <- DATA[-i,]
    Yminus1 <- DESIGN[-i,]
    #DICAminus1 <- tepDICA(Xminus1,DESIGN=Yminus1,make_design_nominal=FALSE,make_data_nominal=FALSE,hellinger=hellinger,symmetric=symmetric,weights=weights,group.masses=group.masses,graphs=FALSE,k=k)
    DICAminus1 <- tepDICA(Xminus1,DESIGN=Yminus1,make_design_nominal=FALSE,make_data_nominal=FALSE,symmetric=symmetric,weights=weights,group.masses=group.masses,graphs=FALSE,k=k)		
    supX <- supplementaryRows(SUP.DATA=t(DATA[i,]), res=DICAminus1)
    assignSup <- fii2fi(DESIGN=t(DESIGN[i,]), fii=supX$fii, fi=DICAminus1$TExPosition.Data$fi)
    return(list(assignSup=assignSup,supX=supX))
  }
  
  #permute.tests <- function(DATA, DESIGN = NULL, group.masses = NULL, weights = NULL, hellinger = FALSE, symmetric = TRUE, k = 0){
  permute.tests <- function(DATA, DESIGN = NULL, group.masses = NULL, weights = NULL, symmetric = TRUE, k = 0){		
    
    PermDATA <- DATA[sample(nrow(DATA),nrow(DATA),FALSE),]
    #res.perm <- tepDICA(PermDATA,DESIGN=DESIGN,make_design_nominal=FALSE,make_data_nominal=FALSE,hellinger=hellinger,symmetric=symmetric,weights=weights,group.masses=group.masses,graphs=FALSE,k=k)
    res.perm <- tepDICA(PermDATA,DESIGN=DESIGN,make_design_nominal=FALSE,make_data_nominal=FALSE,symmetric=symmetric,weights=weights,group.masses=group.masses,graphs=FALSE,k=k)
    
    perm.r2 <- res.perm$TExPosition.Data$assign$r2
    perm.eigs <- res.perm$TExPosition.Data$eigs	
    perm.inertia <- sum(perm.eigs)
    return(list(perm.r2=perm.r2,perm.eigs=perm.eigs,perm.inertia=perm.inertia))
  }
  ############################
  
  DATA <- as.matrix(DATA)
  if(make_data_nominal){
    DATA <- makeNominalData(DATA)
  }
  
  DESIGN <- as.matrix(DESIGN)
  if(make_design_nominal){
    DESIGN <- makeNominalData(DESIGN)
  }
  
  #fixed.res <- tepDICA(DATA=DATA, make_data_nominal = FALSE, DESIGN = DESIGN, make_design_nominal = FALSE, group.masses = group.masses, ind.masses = ind.masses, weights = weights, hellinger = hellinger, symmetric = symmetric, graphs = FALSE, k = k)
  fixed.res <- tepDICA(DATA=DATA, make_data_nominal = FALSE, DESIGN = DESIGN, make_design_nominal = FALSE, group.masses = group.masses, weights = weights, symmetric = symmetric, graphs = FALSE, k = k)
  
  n.rows <- nrow(DATA)
  resamp.iters <- max(n.rows,test.iters)
  
  ##inf stuff
  ncomps <- fixed.res$TExPosition.Data$pdq$ng
  FBY <- array(0,dim=c(nrow(fixed.res$TExPosition.Data$X),ncomps,test.iters))
  FBX <- array(0,dim=c(ncol(fixed.res$TExPosition.Data$X),ncomps,test.iters))
  eigs.perm.matrix <- matrix(0,test.iters,ncomps)
  r2.perm <- inertia.perm <- matrix(0,test.iters,1)
  
  ##loo stuff
  loo.assign <- matrix(0,n.rows,ncol(DESIGN))
  loo.fii <- matrix(0,nrow(DESIGN),ncomps)	
  
  
  #boot & perm test next
  pb <- txtProgressBar(1,test.iters,1,style=1)
  for(i in 1:resamp.iters){
    if(i==1){ ##begin the inference clock.
      inf.start.time <- proc.time()
    }
    
    if(i <= test.iters){
      boot.res <- boot.compute.fi.fj(DATA,DESIGN,fixed.res)
      FBX[,,i] <- boot.res$FBX
      FBY[,,i] <- boot.res$FBY
      #permute.res <- permute.tests(DATA=DATA, DESIGN = DESIGN, group.masses = group.masses, weights = weights, hellinger = hellinger, symmetric = symmetric, k = k)
      permute.res <- permute.tests(DATA=DATA, DESIGN = DESIGN, group.masses = group.masses, weights = weights, symmetric = symmetric, k = k)
      eigs.perm.matrix[i,] <- permute.res$perm.eigs
      r2.perm[i,] <- permute.res$perm.r2
      inertia.perm[i,] <- permute.res$perm.inertia
    }
    
    if(i == 1){ ##end the inference clock; begin the loo clock.
      transition.time <- proc.time()
      inf.cycle.time <- transition.time - inf.start.time
      loo.start.time <- transition.time
    }
    
    if(i <= n.rows){
      #loo.test.res <- loo.test(DATA=DATA, DESIGN = DESIGN, group.masses = group.masses, weights = weights, hellinger = hellinger, symmetric = symmetric, k = k, i)
      loo.test.res <- loo.test(DATA=DATA, DESIGN = DESIGN, group.masses = group.masses, weights = weights, symmetric = symmetric, k = k, i)
      loo.assign[i,] <- loo.test.res$assignSup$assignments
      loo.fii[i,] <- loo.test.res$supX$fii
    }
    
    if(i == 1){ ##end the loo clock and interact with user.
      loo.cycle.time <- proc.time() - loo.start.time
      
      if(!continueResampling((inf.cycle.time [1] * test.iters) + (loo.cycle.time[1]*n.rows))){
        ##exit strategy.
        return(fixed.res)
      }
    }
    setTxtProgressBar(pb,i)		
  }
  
  rownames(FBX) <- colnames(DATA)
  rownames(FBY) <- colnames(DESIGN)
  x.boot.tests <- boot.ratio.test(FBX,critical.value)
  class(x.boot.tests) <- c("tinpoBootTests","list")
  fj.boot.data <- list(tests=x.boot.tests,boots=FBX)
  class(fj.boot.data) <- c("tinpoBoot","list")	
  y.boot.tests <- boot.ratio.test(FBY,critical.value)
  class(y.boot.tests) <- c("tinpoBootTests","list")	
  fi.boot.data <- list(tests=y.boot.tests,boots=FBY)
  class(fi.boot.data) <- c("tinpoBoot","list")
  boot.data <- list(fj.boot.data=fj.boot.data,fi.boot.data=fi.boot.data)
  class(boot.data) <- c("tinpoAllBoots","list")	
  
  eigs.perm.matrix <- round(eigs.perm.matrix,digits=15)
  component.p.vals <- 1-(colSums(eigs.perm.matrix < matrix(fixed.res$TExPosition.Data$eigs,test.iters, ncomps,byrow=TRUE))/test.iters)
  component.p.vals[which(component.p.vals==0)] <- 1/test.iters
  components.data <- list(p.vals=round(component.p.vals,digits=4), eigs.perm=eigs.perm.matrix, eigs=fixed.res$TExPosition.Data$eigs)
  class(components.data) <- c("tinpoComponents","list")
  
  omni.p <- max(1-(sum(inertia.perm < sum(fixed.res$TExPosition.Data$eigs))/test.iters),1/test.iters)
  omni.data <- list(p.val=round(omni.p,digits=4),inertia.perm=inertia.perm,inertia=sum(fixed.res$TExPosition.Data$eigs))
  class(omni.data) <- c("tinpoOmni","list")	
  
  r2.p <- max(1-(sum(r2.perm < sum(fixed.res$TExPosition.Data$assign$r2))/test.iters),1/test.iters)
  r2.data <- list(p.val=round(r2.p,digits=4),r2.perm=r2.perm,r2=fixed.res$TExPosition.Data$assign$r2)
  class(r2.data) <- c("tinpoR2","list")		
  
  loo.confuse <- t(loo.assign) %*% DESIGN	
  rownames(loo.confuse) <- paste(colnames(DESIGN),"predicted",sep=".") 
  colnames(loo.confuse) <- paste(colnames(DESIGN),"actual",sep=".")
  fixed.confuse <- fixed.res$TExPosition.Data$assign$confusion
  loo.acc <- sum(diag(loo.confuse))/sum(loo.confuse)
  fixed.acc <- sum(diag(fixed.confuse))/sum(fixed.confuse)	
  loo.data <- list(loo.assign=loo.assign, loo.fii=loo.fii, loo.confuse=loo.confuse, fixed.confuse=fixed.confuse, loo.acc=loo.acc, fixed.acc=fixed.acc)
  class(loo.data) <- c("tinpoLOO","list")
  
  Inference.Data <- list(omni=omni.data,r2=r2.data,components=components.data,boot.data=boot.data,loo.data=loo.data)
  class(Inference.Data) <- c("tepDICA.inference.battery","list")
  
  ret.data <- list(Fixed.Data=fixed.res,Inference.Data=Inference.Data)
  class(ret.data) <- c("tinpoOutput","list")
  
  if(graphs){
    tinGraphs(ret.data)
  }
  
  return(ret.data)
}

