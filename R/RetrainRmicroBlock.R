#
# Henry Samuelson
#
# Algorithmn Retraining but instead of as much ground truth as possible being prossed like retrainR this processes one by one.
#
# ** THIS IS UNFININSH AND STILL IN DEVELOPMENT **
#



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

  #
  # *THIS IS WHERE THIS IS DIFFERENT *
  # unlike retrainR instead of adding all the new truth we need to test every indivudal part.
  passingTruth <- numeric()
  passingTruthCounter <- 1
  for(j in 1:length(newTruth[,1])) {# for every item compute new accuracy
    tempTrain <- cbind(trainData, newTruth[j,])
    higgsNN3 <- nnCoreV3$new(Label ~ ., data= trainData, hidden = 30, plotData = T)
    cat("DataTest Round:", j)

    higgsNN3$train(9999, trace = 1e3, learn_rate = .0001)
    refScorez <- mean(higgsNN3$predict(data.matrix(cbind(1, refernceData[,-32]))) == refernceData[,32])
    print(refScorez)
    if((refScorez - refScore) > 0.01){
      passingTruth[passingTruthCounter] <- newTruth[j,]
      passingTruthCounter = passingTruthCounter + 1
    }
  }
  #ammend newTruth to the trainingset
  trainData <- rbind(trainData, newTruth)
}
