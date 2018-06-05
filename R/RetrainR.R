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


#Higgs Dataset
higgsDat <- read.csv("C:/Users/hsamuelson/Desktop/R/Higgs/training/training.csv")
higgsDat <- higgsDat[,-1]

trainData <- higgsDat[1:150,]
testData <- higgsDat[151:230,]

higgsNN2 <- nnCoreV2$new(Label ~ ., data= trainData, hidden = 30, plotData = T)
higgsNN2$train(9999, trace = 1e3, learn_rate = .0001)


score <- higgsNN2$predict(data.matrix(cbind(1, testData[,-32]))) == testData[,32]
mean(score) #This will be the effective accuracy of the algorithm
#0.6625

higgsNN2$predict(data.matrix(cbind(1, testData[1,-32])))
