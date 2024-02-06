# This script is to conduct analyses for "Computational Markers of Alzheimer's Disease". The Analyses have several steps: 1. Clean Data; 2 Doing PCA for each block; 3. Compare results from MCA to PCA; 4. Bin the results; 5. MUDICA analyses

library(PTCA4CATA)
library(TExPosition)
library(data4PCCAR)
library(ExPosition)
library(ggplot2)
library(readxl)
library(psych)
source("functions.R")


# Read the dataset
file_path <- '/Users/yilewang/workspaces/data4project/mega_table.xlsx'
table <- as.data.frame(read_excel(file_path, sheet="hodgepodge", skip=1))

# Each block
ignition.table <- table[13:28]
tvb_para.table <- table[31:35]
MC.table <- table[39:51]
SimFreq.table <- table[52:56]
sc.table <- table[66:74]
wdc.table <- table[75:91]

# Bins the data
bins.table <- as.data.frame(table)
for(i in 31:35){
  bins.table[,i] <- bins_helper(bins.table[,i], 
                                colnames(bins.table)[i])
}
hist.afterbin <- multi.hist(bins.table[,31:35])


# PCA
res.PCA <- epPCA(DATA = table[13:28], center = TRUE,
                 scale = 'SS1',
                 DESIGN = table$group, graphs = FALSE)

# Multiple Corresponding Analysis
res.MCA <- epMCA(DATA = bins.table[7:35], 
                 DESIGN = table$group, 
                 graphs = FALSE)

res.MCA.inf <- epMCA.inference.battery(DATA = bins.table[7:35], 
                                       DESIGN = table$group, 
                                       graphs = FALSE)






