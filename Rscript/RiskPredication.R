#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1) {
	stop("At least 1 argument must be supplied (input file).", call.=FALSE)
} else if (length(args)==1) {
	# default output file
	args[2] = "./Temp"
}

dataUrl <- args[1]
outputPath <- args[2]
reportPath <- paste(outputPath,'risk-prediction-report.txt', sep='/')
resultsPath <- paste(outputPath,'risk-prediction-results.txt', sep='/')

modelUrl <- "./Model/riskPredictionModel.rds"

# dataUrl <- "./Data/Input_Data_Example.csv"
# outputPath <- "./Temp"
# reportPath <- paste(outputPath,'risk-predication-model-training-report.txt', sep='/')

library(lattice)
library(ggplot2)
library(neuralnet)

# setwd("E:/WorkSpace/Huawei/R/Risk_Prediction_Model_Calibration")
#sink(reportPath, append=TRUE, split=TRUE)
sink(reportPath)

df <- read.csv(dataUrl, header=TRUE, sep=",")
names <- colnames(df)
#print('names')
#riskLabels <- names[grepl("RISK*", names)];
#print(paste(paste(riskLabels, collapse= "+"), paste(names[!names %in% riskLabels], collapse= "+"), sep="~"))
#f <- as.formula(paste("RISK1+RISK2+RISK3+RISK4+RISK5~", paste(names[!names %in% "RISK*"], collapse= "+"))) #making a formula to fit to neural net
#f <- as.formula(paste(paste(riskLabels, collapse= "+"), paste(names[!names %in% riskLabels], collapse= "+"), sep="~")) #making a formula to fit to neural net
#print(f)

#nn <- neuralnet(f, data=df, hidden=3, act.fct = "logistic", linear.output = FALSE) #model with one hidden layer and one neuron

# The information that is printed will be output into risk-predication-model-training-report.txt
#print(nn)

nn <- readRDS(modelUrl)

print("prediction calculation with:")
#print(nn$model.list$variables)
variables = nn$model.list$variables
names <- colnames(df)
print(df[, names[names %in% variables]])
pr.nn <- compute(nn,df[, names[names %in% variables]])
predictions = as.matrix(apply(pr.nn$net.result, 1, FUN=which.max))

print("prediction results:")
print(pr.nn$net.result)
print(predictions)

sink(resultsPath)
print(paste('risk_lvl1', 'risk_lvl2', 'risk_lvl3', 'risk_lvl4', 'risk_lvl5', 'predicted', sep=" "));

for( i in 1:nrow(pr.nn$net.result)){
print(paste(pr.nn$net.result[i,1], pr.nn$net.result[i,2], pr.nn$net.result[i,3], pr.nn$net.result[i,4], pr.nn$net.result[i,5], predictions[i,1], sep=" "));
}
#print(paste("risk_lvl1 ", pr.nn$net.result[1,1]));
#print(paste("risk_lvl2 ", pr.nn$net.result[1,2]));
#print(paste("risk_lvl3 ", pr.nn$net.result[1,3]));
#print(paste("risk_lvl4 ", pr.nn$net.result[1,4]));
#print(paste("risk_lvl5 ", pr.nn$net.result[1,5]));
#print(paste("predicted ", predictions[1,1]))

#plot(nn)

sink()