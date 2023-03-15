devtools::install_github('chz31/SlicerMorphR')
install.packages("janitor", "dplyr", "readxl", "tidyverse")

.packs<-c("SlicerMorphR", "dplyr", "readxl", "janitor", "tidyverse")
lapply(.packs, require, character.only=T)



save.dir='DIR ' 
##enter your directory to download the MALPACA data sample or the DIR where you are working

setwd(save.dir)

  MAL_outDir_git<- paste(save.dir, " /", sep="/") 
  ##Set up MALPACA output path, the one where you got the folders individual/median .fcsv from the 3Dslicer
  
  templates_path_git<- 'DIR ' 
  ##Set up the folder where the templates landmarks are
  
  LMs <-read.malpaca.estimates(MALPACA_outputDir = MAL_outDir_git, templates_Dir = templates_path_git)
  
  allEst <- LMs$allEstimates 
  ##Store all individual estimates in a 4D array [i, j, k, n]. //
  ##i = number of landmarks; j = dimension; k = number of templates; n = sample size //
  ##For example:
  
  #allEst[1:2, , 1,3]
  ##(The LM1 to LM2 estimated by template 1 -26672- for target specimen 3 -FMNH 69858-)
  
  ##     x         y        z
  ## 1 10.94436 -36.31236 11.07754
  ## 2 39.59183 -21.46928 17.12281
  
  MAL_medians <- LMs$MALPACA_medians 
  ##Store all median estimates in a 3D array [i, j, n]. i = number of templates; j = dimension; n = sample size. 
  ##For example:
  
  #MAL_medians[1:2,,3]
  ##(The median estimates for LM1 and LM2 of the target specimen 3 -FMNH 69858-)
  ##   x         y        z
  ## 1 11.48924 -36.31236 13.98122
  ## 2 38.83655 -24.08117 17.12281
  
  outPath<- paste(MAL_outDir_git, sep="/") 
  
  outliers <- extract.outliers(allEstimates = allEst, MALPACA_medians =
                                 MAL_medians, outputPath = outPath)
  #outliers$estimates_no_out[18:23, , 2, 2]


medians <- as.array(get.medians(AllLMs = outliers$estimates_no_out, outlier.NA = TRUE))
## get.medians()" function from SlicerMorphR to generate new median estimates for each specimen,
## storing in a 3D array [i, j, n]. i = number of templates; j = dimension; n = sample size

nombres = attr(MAL_medians,"dimnames")
nombres = as.list(nombres[[3]])

setwd(outPath)
folDir<- "newMedians"
if (file.exists(folDir)) {
  cat("The folder already exists")
} else { dir.create(folDir)}

pathMed<-paste(outPath, 'medianEstimates', sep='/')
## path where the MALPACA medians are

setwd(pathMed)

files <- list.files(pattern="*.fcsv")
newfiles <- gsub(".fcsv$", ".csv", files)
file.rename(files, newfiles)


listaCsv <- list.files(pathMed,pattern="*.csv")

for (i in 1:length(nombres)){
  oldMedian<-read.csv(file=listaCsv[i], header=FALSE, sep = ",")
  for (j in 2:4){
    oldMedian[4:nrow(oldMedian),j]<-1
    oldMedian[4:nrow(oldMedian),j]<-medians[,j-1,i]
 }
  lastFile<-oldMedian
  names(lastFile)<-NULL
  write.csv(lastFile,file=paste0(outPath, '/newMedians/', 
                                 nombres[[i]],'.fcsv'),row.names=FALSE, quote = FALSE )
}
  
fileCsv <- list.files(pattern="*.csv")
fileSlicer <- gsub(".csv$", ".fcsv", fileCsv)
file.rename(fileCsv, fileSlicer)
