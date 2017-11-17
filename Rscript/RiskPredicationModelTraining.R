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
reportPath <- paste(outputPath,'risk-predication-model-training-report.txt', sep='/')

# dataUrl <- "./Data/Input_Data_Example.csv"
# outputPath <- "./Temp"
# reportPath <- paste(outputPath,'risk-predication-model-training-report.txt', sep='/')

library(lattice)
library(ggplot2)
library(neuralnet)

# setwd("E:/WorkSpace/Huawei/R/Risk_Prediction_Model_Calibration")
sink(reportPath, append=TRUE, split=TRUE)

df <- read.csv(dataUrl, header=TRUE, sep=",")
names <- colnames(df)

f <- as.formula(paste("RISK~", paste(names[!names %in% "RISK"], collapse= "+"))) #making a formula to fit to neural net

nn <- neuralnet(f, data=df, hidden=1, act.fct = "logistic", linear.output = FALSE) #model with one hidden layer and one neuron

print(nn)
plot(nn)