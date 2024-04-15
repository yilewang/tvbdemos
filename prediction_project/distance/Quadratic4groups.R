# This script is to conduct analyses for "Computational Markers of Alzheimer's Disease". The Analyses have several steps: 1. Clean Data; 2 Doing PCA for each block; 3. Compare results from MCA to PCA; 4. Bin the results; 5. MUDICA analyses

library(PTCA4CATA)
library(TExPosition)
library(TInPosition)
library(data4PCCAR)
library(ExPosition)
library(InPosition)
library(ggplot2)
library(readxl)
library(psych)
source("functions.R")
library(gridExtra)
library(ggplotify)
library(grid)
library(knitr)


# Read the dataset
file_path <- "/Users/yilewang/workspaces/data4project/prediction_project/quadratic.xlsx"
table <- as.data.frame(read_excel(file_path, ))
# four groups definition
levels(table$group) <- c("SNC","NC","MCI","AD")


# manually setting color design
m.color.design <- as.matrix(colnames(table))

# Each block
ignition.table <- table[3:13]
m.color.design[3:13] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

tvb_para.table <- table[14:16]
m.color.design[14:16] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

SimFreq.table <- table[17:18]
m.color.design[17:18] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

sc.table <- table[19:23]
m.color.design[19:23] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

wdc.table <- table[24:29]
m.color.design[24:29] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

##########################################
# the color of participants
ob.color.design <- as.matrix(rownames(table))
ob.color.design[1:10] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[11:26] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[27:61] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[62:74] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
##########################################
end_col <- length(colnames(table))
start_col <- 3
hist.beforebin <- multi.hist(table[,start_col:end_col])
# Bins the data
bins.table <- as.data.frame(table)

for(i in start_col:end_col){
  bins.table[,i] <- bins_helper(bins.table[,i], 
                                colnames(bins.table)[i])
}
hist.afterbin <- multi.hist(bins.table[,start_col:end_col])


data.table <- SimFreq.table

# PCA
# res.PCA <- epPCA(DATA = data.table, center = TRUE,
#                  scale = 'SS1',
#                  DESIGN = table$group, graphs = FALSE)
# 
# res.PCA.inf <- epPCA.inference.battery(DATA = data.table, 
#                                        center = TRUE,
#                                        scale = 'SS1',
#                                        DESIGN = table$group, 
#                                        graphs = FALSE)
# 
# plot.scree(res.PCA$ExPosition.Data$eigs, res.PCA.inf$Inference.Data$components$p.vals)
# plot.permutation(res.PCA.inf$Inference.Data$components$eigs.perm, res.PCA$ExPosition.Data$eigs)



# Multiple Corresponding Analysis

# res.MCA <- epMCA(DATA = bins.table[13:end_col],
#                  DESIGN = table$group, 
#                  graphs = FALSE)
# res.MCA.inf <- epMCA.inference.battery(DATA = bins.table[13:end_col],
#                                        DESIGN = table$group, graphs = FALSE)

# plot.scree(res.MCA$ExPosition.Data$eigs, res.MCA.inf$Inference.Data$components$p.vals)
# plot.permutation(res.MCA.inf$Inference.Data$components$eigs.perm, res.MCA$ExPosition.Data$eigs)

# DICA

g.masses <- NULL

# g.masses <-  rep(1 / ncol(makeNominalData(bins.table[13:end_col])), length(unique(descriptors$AgeGen)))
res.DICA <- tepDICA(bins.table[start_col:end_col], make_data_nominal = TRUE, symmetric = TRUE,
                    group.masses = g.masses,
                    #weight = rep(1, nrow(XYmat)),# -- if equal weights for all columns,
                    DESIGN = table$group, graphs = FALSE)

# Inferences ----
set.seed(70301) # set the seed

# For random effects model so that we all have the same results.
nIter = 1000
res.DICA.inf <- tepDICA.inference.battery(bins.table[start_col:end_col], make_data_nominal = TRUE, symmetric = TRUE,
                                          DESIGN = table$group,
                                          group.masses = g.masses,
                                          test.iters = nIter,
                                          #weight = rep(1, nrow(XYmat)), # -- if equal weights for all columns,
                                          graphs = FALSE)

plot.scree(res.DICA$TExPosition.Data$eigs, res.DICA.inf$Inference.Data$components$p.vals)
plot.permutation(res.DICA.inf$Inference.Data$components$eigs.perm, res.DICA$TExPosition.Data$eigs)


# get levels of color
col4Levels <- data4PCCAR::coloringLevels(
  rownames(res.DICA$TExPosition.Data$fj), m.color.design)
col4Labels <- col4Levels$color4Levels



### make correlation plot
# get some color
col4Levels <- data4PCCAR::coloringLevels(
  rownames(res.DICA$TExPosition.Data$fj), m.color.design[start_col:end_col])
col4Labels <- col4Levels$color4Levels

# plot color
col <-colorRampPalette(c("#BB4444", 
                         "#EE9988", 
                         "#FFFFFF", 
                         "#77AADD", 
                         "#4477AA"))

corrMatBurt.list <- phi2Mat4BurtTable(bins.table[start_col:end_col])
# plot
corr4MCA.r <- corrplot::corrplot(
  as.matrix(corrMatBurt.list$phi2.mat^(1/2)),
  method="color", 
  col=col(200),
  type="upper",
  #addCoef.col = "black",
  tl.col = m.color.design[start_col:end_col],
  tl.cex = .7,
  tl.srt = 60,#Text label color and rotation
  #number.cex = .5,
  #order = 'FPC',
  diag = TRUE # needed to have the color of variables correct
)

# rename fii
rownames(res.DICA$TExPosition.Data$fii) <- bins.table$caseid
plot.fs(bins.table$group, 
        res.DICA$TExPosition.Data$fii, 
        res.DICA$TExPosition.Data$eigs, 
        res.DICA$TExPosition.Data$t, 
        d=1, 
        mode="CI", 
        method = "DICA")

plot.loading(bins.table[start_col:end_col], col=m.color.design[start_col:end_col], res.DICA$TExPosition.Data$fii, res.DICA$TExPosition.Data$eigs, res.DICA$TExPosition.Data$t, d=1)

plot.cfs(res.DICA$TExPosition.Data$fj, res.DICA$TExPosition.Data$eigs, res.DICA$TExPosition.Data$t, d=1, col=col4Labels, method="DICA", colrow="row")

plot.cb(res.DICA$TExPosition.Data$cj, res.DICA$TExPosition.Data$fj, col = col4Labels, boot.ratios=res.DICA.inf$Inference.Data$boot.data$fj.boot.data$tests$boot.ratios, signifOnly = TRUE, fig = 2, horizontal = FALSE, colrow = "col", fontsize = 2)

# Confusion Matrix

fixed.confusion <- res.DICA.inf$Inference.Data$loo.data$fixed.confuse
random.confusion <- res.DICA.inf$Inference.Data$loo.data$loo.confuse
fixed.acc <- res.DICA.inf$Inference.Data$loo.data$fixed.acc
random.acc <- res.DICA.inf$Inference.Data$loo.data$loo.acc

# rename
rownames(fixed.confusion) <- sub("[[:punct:]]","",
                                 rownames(fixed.confusion))
rownames(random.confusion) <- sub("[[:punct:]]","",
                                  rownames(random.confusion))
colnames(fixed.confusion)<- sub("[[:punct:]]","",
                                colnames(fixed.confusion))
colnames(random.confusion)<- sub("[[:punct:]]","",
                                 colnames(random.confusion))
rownames(fixed.confusion) <- paste0(rownames(fixed.confusion), 
                                    ".predicted")
colnames(fixed.confusion) <- paste0(colnames(fixed.confusion),
                                    ".actual")

# print table and accurarcy
kable(fixed.confusion, 
      caption = "Fixed Confustion Matrix")


