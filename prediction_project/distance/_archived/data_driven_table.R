# This script is to conduct analyses for "Computational Markers of Alzheimer's Disease". The Analyses have several steps: 1. Clean Data; 2 Doing PCA for each block; 3. Compare results from MCA to PCA; 4. Bin the results; 5. MUDICA analyses

library(PTCA4CATA)
library(TExPosition)
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

# Read the dataset
file_path <- "/Users/yilewang/workspaces/data4project/prediction_data.xlsx"
table <- as.data.frame(read_excel(file_path, sheet = "data_driven", skip = 1))
levels(table$group) <- c("SNC","NC","MCI","AD")


# manually setting color design
m.color.design <- as.matrix(colnames(table))

# Each block
ignition.table <- table[13:28]
m.color.design[13:28] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

tvb_para.table <- table[29:34]
m.color.design[29:34] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

MC.table <- table[35:42]
m.color.design[35:42] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

SimFreq.table <- table[43:53]
m.color.design[43:53] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

sc.table <- table[54:57]
m.color.design[54:57] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

wdc.table <- table[58:67]
m.color.design[58:67] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))

##########################################
# the color of participants
ob.color.design <- as.matrix(rownames(table))
ob.color.design[1:10] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[11:26] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[27:61] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
ob.color.design[62:74] <- prettyGraphsColorSelection(starting.color = sample(1:170, 1))
##########################################

# Bins the data
bins.table <- as.data.frame(table)
end_col <- length(colnames(table))
for(i in 13:end_col){
  bins.table[,i] <- bins_helper(bins.table[,i], 
                                colnames(bins.table)[i])
}
hist.afterbin <- multi.hist(bins.table[,13:end_col])


data.table <- SimFreq.table

# PCA
res.PCA <- epPCA(DATA = data.table, center = TRUE,
                 scale = 'SS1',
                 DESIGN = table$group, graphs = FALSE)

res.PCA.inf <- epPCA.inference.battery(DATA = data.table, 
                                       center = TRUE,
                                       scale = 'SS1',
                                       DESIGN = table$group, 
                                       graphs = FALSE)

plot.scree(res.PCA$ExPosition.Data$eigs, res.PCA.inf$Inference.Data$components$p.vals)


plot.permutation(res.PCA.inf$Inference.Data$components$eigs.perm, res.PCA$ExPosition.Data$eigs)



# Multiple Corresponding Analysis



res.MCA <- epMCA(DATA = bins.table[13:end_col],
                 DESIGN = table$group, 
                 graphs = FALSE)
res.MCA.inf <- epMCA.inference.battery(DATA = bins.table[13:end_col],
                                       DESIGN = table$group, graphs = FALSE)


plot.scree(res.MCA$ExPosition.Data$eigs, res.MCA.inf$Inference.Data$components$p.vals)


plot.permutation(res.MCA.inf$Inference.Data$components$eigs.perm, res.MCA$ExPosition.Data$eigs)



# get levels of color
col4Levels <- data4PCCAR::coloringLevels(
  rownames(res.MCA$ExPosition.Data$fj), m.color.design)
col4Labels <- col4Levels$color4Levels



### make correlation plot
# get some color
col4Levels <- data4PCCAR::coloringLevels(
  rownames(res.MCA$ExPosition.Data$fj), m.color.design[13:end_col])
col4Labels <- col4Levels$color4Levels

# plot color
col <-colorRampPalette(c("#BB4444", 
                         "#EE9988", 
                         "#FFFFFF", 
                         "#77AADD", 
                         "#4477AA"))

corrMatBurt.list <- phi2Mat4BurtTable(bins.table[13:end_col])
# plot
corr4MCA.r <- corrplot::corrplot(
  as.matrix(corrMatBurt.list$phi2.mat^(1/2)),
  method="color", 
  col=col(200),
  type="upper",
  #addCoef.col = "black",
  tl.col = m.color.design[13:86],
  tl.cex = .7,
  tl.srt = 60,#Text label color and rotation
  #number.cex = .5,
  #order = 'FPC',
  diag = TRUE # needed to have the color of variables correct
)

# rename fi
rownames(res.MCA$ExPosition.Data$fi) <- bins.table$caseid
plot.fs(bins.table$group, 
        res.MCA$ExPosition.Data$fi, 
        res.MCA$ExPosition.Data$eigs, 
        res.MCA$ExPosition.Data$t, 
        d=1, 
        mode="CI", 
        method = "MCA")

plot.loading(bins.table[13:end_col], col=m.color.design[13:end_col], res.MCA$ExPosition.Data$fi, res.MCA$ExPosition.Data$eigs, res.MCA$ExPosition.Data$t, d=1)

plot.cfs(res.MCA$ExPosition.Data$fj, res.MCA$ExPosition.Data$eigs, res.MCA$ExPosition.Data$t, d=1, col=col4Labels, method="MCA", colrow="row")

plot.cb(res.MCA$ExPosition.Data$cj, res.MCA$ExPosition.Data$fj, col = col4Labels, boot.ratios=res.MCA.inf$Inference.Data$fj.boots$tests$boot.ratios, signifOnly = TRUE, fig = 2, horizontal = FALSE, colrow = "col", fontsize = 2)

