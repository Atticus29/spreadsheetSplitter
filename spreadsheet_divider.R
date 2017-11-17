#########################################
##File name of spreadsheet to read from##
#########################################
fileString = "/Users/mf/2014_and_beyond/Academic/Teaching/Courses/PCC/Biology_101_Fall_2017/master_grades.csv" 

################
##Read in file##
################
require(data.table)
data = read.csv(file =fileString , header=T, sep=",", stringsAsFactors = FALSE)
data=as.data.table(data)

#############
##Variables##
#############
colSubset = colnames(data)[1:16] #TODO edit this as needed
dataOnlyImportantCols = data[,colSubset,with=F]
colsManualExclusion = colSubset[!colSubset %in% c("First_Name", "Last_Name","Raw_quiz2_out_of_9", "Quiz3_Grade_out_of_8")] #TODO edit this as needed

############################################
##Apply rowSums and percentage calculation##
############################################
dataShortened = data[,colsManualExclusion, with =F]
dataShortened[] <- lapply(dataShortened, function(x) as.numeric(as.character(x)))
dataShortened[,Total := rowSums(.SD,na.rm=TRUE), .SDcols=colsManualExclusion]
dataShortened[,TotalPercent := Total*100/120] #TODO edit the 120 for the total points as needed
dataOnlyImportantCols = data.table(dataOnlyImportantCols, dataShortened[,c("Total", "TotalPercent"), with=F])
lastRow = nrow(dataOnlyImportantCols)

##############################################################
##Perhaps there's a mean row to add to each sub spreadsheet?##
##############################################################
rowNumToIncludeInEach = lastRow #TODO edit this as needed

#########################################
##Make the spreadsheet for each student##
#########################################
for(r in c(1:lastRow-1)){
  newFileName = paste("/Users/mf/2014_and_beyond/Academic/Teaching/Courses/PCC/Biology_101_Fall_2017/", dataOnlyImportantCols[r,Last_Name],"_grades.csv") #TODO edit this as needed
  write.table(as.data.frame(dataOnlyImportantCols[c(rowNumToIncludeInEach,r),]),file = newFileName, quote=FALSE, sep=",", col.names = TRUE, row.names = FALSE)
}
