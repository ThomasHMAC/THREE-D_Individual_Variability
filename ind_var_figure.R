#load libraries
library(corrplot)
library(tidyverse)
library(rdist)
#Read in all subjects text files
list_of_files <- list.files(path = "/mnt/tigrlab/projects/ttan/ThirtyFourD/analysis/LDLPFC_connectivity/",
                            #pattern = "_LDLPFC.txt$",
                            pattern = ".*ses-pretx.*\\.txt$",
                            full.names = TRUE)

list_of_files <- list.files(path = "/mnt/tigrlab/projects/ttan/ThirtyFourD/analysis/R_sgACC_connectivity/",
                            pattern = ".*ses-pretx.*\\.txt$",
                            full.names = TRUE)

list_of_files <- list.files(path = "/mnt/tigrlab/projects/ttan/ThirtyFourD/analysis/insular_connectivity/",
                            #pattern = "_insular.txt$",
                            pattern = ".*ses-pretx.*\\.txt$",
                            full.names = TRUE)
list_of_files <- list.files(path = "/mnt/tigrlab/projects/ttan/ThirtyFourD/analysis/precuneus_connectivity/",
                            #pattern = "_LDLPFC.txt$",
                            pattern = ".*ses-pretx.*\\.txt$",
                            full.names = TRUE)

#read text files need[1:59,412]
# Extract all the left and right vertices (59412)
txt_files_df <- lapply(list_of_files, function(x) {x = read.table(file = x, header = FALSE, sep =",", nrows = 59412)})
#combie text files into a dataframe
combined_df <- do.call("cbind", lapply(txt_files_df, as.data.frame))
#90 participants (rows) by 59,412 voxels (columns)
df.final <- as.data.frame(t(combined_df))

#pairwise correlational distance
#pairwise distance measure 0 to 1, 0 is less distance = more similar, 1 is more distance = less similar
corr = rdist::pdist(df.final, metric = "correlation")

#calculate mean distance for each subject
#corr[corr ==0] = NA
corr_new <- replace(corr[,],corr[,] == 0, NA)
mean_corr_distance_df <- data.frame('',Meandist=rowMeans(corr_new,na.rm=TRUE))
for (i in 1:length(list_of_files)){
  str_split <- strsplit(basename(list_of_files[i]),"_")
  subid <- str_split[[1]][1]
  mean_corr_distance_df$X..[i] <- subid
}

write.csv(mean_corr_distance_df,"/projects/ttan/ThirtyFourD/analysis/3D_LDLPFC_mean_distance_posttx_fixed.csv",row.names = FALSE)

#################################
corr = rdist::pdist(df.final, metric = "correlation")
corrdf = as.data.frame(corr)
#rows belong to MDD and add unique identifier (to make sure sorting properly
rownames(corrdf) <- paste(c(rep('MDD', 252)), seq(1:nrow(corrdf)), sep='_')
colnames(corrdf) <- rownames(corrdf)
#change diagnoal values from 0 to lowest value, to maximize scale
diag(corrdf) <- 0.4573973 

#################################
#Order by increased MCD
order <- colnames(corrdf[order(colSums(corrdf[, names(corrdf)]))])
#reorganize corrmat as desired
corrdf_order <- corrdf[order,order]

#################################
#MAKE PLOT
#set custom colour scale, for plot
#myColours <- colorRampPalette(c("white", "white", "blue", "green"))
myColours <- colorRampPalette(c("blue", "green")) 
#make sure corrmat is a matrix, for plotting
corrdf_order <- as.matrix(corrdf_order)
#visualize matrix for HC only
diag(order) <- 0.4573973
diag(corrdf_order) <- 0.4046116
min(corrdf_order)

# Plot pairwise distance matrix for MDD 
corrplot(corrdf_order,method='color',col.lim=c(0.35,0.76),col=myColours(100),is.corr = FALSE)

# Color by group
#corrplot(corrdf, 
#         method='color', #get full square, instead of circles
#         col.lim=c(0.3,1), #set limits of colour scale
#         cl.length =3,
#         col=myColours(100)) #|> corrRect(index = c(1,34,34,90)) #use 100 unique colour shared
#r= (c(sum(grepl('MDD', colnames(corrdf))), sum(grepl('HCS', colnames(corrdf)))))
#corrRect(corrRes=p, namesMat = r)
