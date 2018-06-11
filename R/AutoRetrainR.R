#
# Henry Samuelson
#
# AutoRetrainR
#
# The same as RetrainR.R but automated loop with logic process
higgsDat <- read.csv("C:/Users/hsamuelson/Desktop/R/Higgs/training/training.csv")
higgsDat <- higgsDat[,-1]


higLowerBound <<- 151
higUpperBound <<- 301
#This switches around what the testData is so it is always new.
datShifter <- function(){ #This function should be called after runResults() becasue it needs to take the first set of data
  trainData <<- higgsDat[1:150,]
  testData <<- higgsDat[higLowerBound:higUpperBound,]
  refernceData <- higgsDat[249800:250000,]
  higLowerBound <<- higUpperBound + 1
  higUpperBound <<- higUpperBound + 151

}

## FUNCTIONS NOW
runResults <- function() {

  higgsNN2 <- nnCoreV3$new(Label ~ ., data= trainData, hidden = 30, plotData = T)
  higgsNN2$train(9999, trace = 1e3, learn_rate = .0001)
  #
  # By training will add on to var superScore but will be overwritten when an $predict() command is run.
  #

  # This is what will be comparied to benchmark progress throughout different input data
  mean(higgsNN2$predict(data.matrix(cbind(1, refernceData[,-32]))) == refernceData[,32]) #also important this is calculated first

  # This simutaniously generates the confiendece table called superScore
  predictedData <- higgsNN2$predict(data.matrix(cbind(1, testData[,-32])))
  score <-  predictedData == testData[,32]
  oldScore <- mean(score) #This will be the effective accuracy of the algorithm
  #~.59444
  #~.61666
  #~.61111



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
  trainData <<- rbind(trainData, newTruth)

  # This last part is a repeat becasue it needs to be run to be tested.
  higgsNN2 <- nnCoreV3$new(Label ~ ., data= trainData, hidden = 30, plotData = T)
  higgsNN2$train(9999, trace = 1e3, learn_rate = .0001)
  #
  # By training will add on to var superScore but will be overwritten when an $predict() command is run.
  #

  # This is what will be comparied to benchmark progress throughout different input data
  mean(higgsNN2$predict(data.matrix(cbind(1, refernceData[,-32]))) == refernceData[,32]) #also important this is calculated first

  # This simutaniously generates the confiendece table called superScore
  predictedData <- higgsNN2$predict(data.matrix(cbind(1, testData[,-32])))
  score <-  predictedData == testData[,32]
  return(c(oldScore, mean(score)))
}


## MAIN PROCESS

for(i in 1:10){
  print(runResults())
  datShifter()
}
