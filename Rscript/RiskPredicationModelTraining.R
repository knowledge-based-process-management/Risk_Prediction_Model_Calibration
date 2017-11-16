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
#pngPath <- paste(outputPath,'eucp-exucp-linear-regression-plot.png', sep='/')

# store the current directory
# initial.dir<-getwd()
# setwd(workDir)

# cat(initial.dir)
# change to the new directory
# cat(getwd())
# load the necessary libraries

library(lattice)
library(ggplot2)
#library(latticeExtra)
# set the output file
#library(reshape)
library(neuralnet)

sink(reportPath)

#setwd("C:/Users/vimal/Documents/DR_machine_learning")
#df <- read.csv("UCP_DatasetV1.8.csv",header = TRUE)

df <- read.csv(dataUrl, header=TRUE)

#print("Training Set")
#print(df[,7:9])
#ex <- df[,c(7,8,9)]
#print(ex)
#print(df)
#df1 <- read.csv("UCP_DatasetV1.8.csv",header = TRUE,nrows=10,skip=11)
#print("validation Set")
#print(df1)
#df2 <- read.csv("UCP_DatasetV1.8.csv",header = TRUE,nrows=10,skip=21)
#print("Test Set")
#print(df2)


#N <- 9
#D <- 3 # dimensionality(As we are selecting 6 levels ofcomplexity)(Now 3)

#X1 <- df[1:9,c(7,8,9,15)] # data matrix (each row = single example)(Input data)
#X1_TEST <- df[10,c(7,8,9,15)]

#X2 <- df[11:19,c(7,8,9,15)] # data matrix (each row = single example)(Input data)
#X2_TEST <- df[20,c(7,8,9,15)]

#X3 <- df[21:29,c(7,8,9,15)] # data matrix (each row = single example)(Input data)
#X3_TEST <- df[30,c(7,8,9,15)]

names <- names(X1)
#print(n)

f <- as.formula(paste("RISK ~ ", paste(names[!names %in% "RISK"], collapse= "+"))) #making a formula to fit to neural net

#nn <- neuralnet(f,data=X1[1:9,],hidden=c(1),linear.output=T) #model with one hidden layer and one neuron
nn <- neuralnet(f, data=df, hidden=c(3), act.fct = "logistic", linear.output = FALSE) #model with one hidden layer and one neuron

plot(nn)

#pr.nn <- compute(nn,X1_TEST[,1:3])
#MSE.nn1 <- (X1_TEST[1,4] - pr.nn$net.result)^2
#print("First iteratiion MSE:")
#print(MSE.nn1)

#also have linear regression on sloc and normalized effort.
sink()
