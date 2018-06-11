#
# Henry Samuelson
#
# Algorithmn Retraining
#
# ** THIS IS UNFININSH AND STILL IN DEVELOPMENT **
#


# #Split Data set
# tData <- infert[1:100,] #train data
# test <- infert[101:length(infert[,1]),] #test data
#
# # Define net
# infertNN2 <- nnCoreV2$new(education ~ ., data= tData, hidden = 6, plotData = T)
#
# #train net
# infertNN2$train(4000, trace = 1e3, learn_rate = .0001)
#
#
#
#
# #run tests
# infertNN2$predict(data.matrix(cbind(1, test[,-1]))) == test[,1]

testData <- higgsDat[151:330,]

#Higgs Dataset
higgsDat <- read.csv("C:/Users/hsamuelson/Desktop/R/Higgs/training/training.csv")
higgsDat <- higgsDat[,-1]
for(i in 1:20){
trainData <- higgsDat[1:150,]
testData <- higgsDat[151+(i*151):330+(i*151),]
refernceData <- higgsDat[500:700,]


higgsNN2 <- nnCoreV3$new(Label ~ ., data= trainData, hidden = 30, plotData = T)
higgsNN2$train(9999, trace = 1e3, learn_rate = .0001)
#
# By training will add on to var superScore but will be overwritten when an $predict() command is run.
#

# This is what will be comparied to benchmark progress throughout different input data
refScore <- mean(higgsNN2$predict(data.matrix(cbind(1, refernceData[,-32]))) == refernceData[,32]) #also important this is calculated first

# This simutaniously generates the confiendece table called superScore
predictedData <- higgsNN2$predict(data.matrix(cbind(1, testData[,-32])))
score <-  predictedData == testData[,32]
#mean(score) #This will be the effective accuracy of the algorithm
#~.59444
#~.61666
#~.61111
print(refScore)


#higgsNN2$predict(data.matrix(cbind(1, testData[1:2,-32])))

#Adapt confiedence table
confiedenceList <- higgsNN2$superScore[,1]

#THis includes both .9 and .1 bc the original list is double and one list is for y other for conf in n
highConfiedence <- confiedenceList[unlist(confiedenceList > .9 | confiedenceList < .1)] #Only includes confiedences that are over .9

#Creates table for of original index and confiedence c(i, .9)
confTable <- cbind(as.integer(names(highConfiedence)), as.numeric(highConfiedence)) #these should now be added to the training set of truth.

#add the indexes to training set, with the predicted vals
#
#get predicted vals
predictIndex <- confTable[,1] - 150 #This number should change
Label <- predictedData[predictIndex] #This is important it is named what it was originally in the dataset
newTruth <- cbind(testData[predictIndex,][,-32], as.data.frame(Label))

#ammend newTruth to the trainingset
trainData <- rbind(trainData, newTruth)
}
