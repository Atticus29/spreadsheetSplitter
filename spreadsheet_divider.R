fileString = "/Users/mf/2014_and_beyond/Academic/Teaching/Courses/PCC/Biology_101_Fall_2017/master_grades.csv" 

require(data.table)
data = read.csv(file =fileString , header=T, sep=",", stringsAsFactors = FALSE)
data=as.data.table(data)
cols = colnames(data)[1:16]
dataAsOfPostLab6 = data[,cols,with=F]

##################################################
##The goal is to make this the only line to edit##
##################################################

colsNoRaw = cols[!cols %in% c("First_Name", "Last_Name","Raw_quiz2_out_of_9", "Quiz3_Grade_out_of_8")]


dataShortened = data[,colsNoRaw, with =F]
dataShortened[] <- lapply(dataShortened, function(x) as.numeric(as.character(x)))

dataShortened[,Total := rowSums(.SD,na.rm=TRUE), .SDcols=colsNoRaw]
dataShortened[,TotalPercent := Total*100/120]

dataAsOfPostLab6 = data.table(dataAsOfPostLab6, dataShortened[,c("Total", "TotalPercent"), with=F])
lastRow = nrow(dataAsOfPostLab6)

for(r in c(1:lastRow-1)){
  write.table(as.data.frame(dataAsOfPostLab6[c(lastRow,r),]),file = paste("/Users/mf/2014_and_beyond/Academic/Teaching/Courses/PCC/Biology_101_Fall_2017/", dataAsOfPostLab6[r,Last_Name],"_grades.csv"), quote=FALSE, sep=",", col.names = TRUE, row.names = FALSE)
}
