

# #TEST SUITE
# nn <- nnCore$new(Species ~ ., data = iris, hidden = 6)
# nn$train(9999, trace = 1e3, learn_rate = .0001)
# nn$predict(data.matrix(cbind(1, iris[,-5])))
# nn$computeNN(iris[,-5])
# nn$nnCoreAccuracy
# nn$train(9999, trace = 1e3, learn_rate = .0001)$predict(data.matrix(cbind(1, iris[,-5])))
#
# nn <- nnCore$new(Species ~ ., data = iris, hidden = "1")
#

#Compare NNs
# nn1 <- nnCore$new(Species ~ ., data = iris, hidden = 6)
# nn1$train(9999, trace = 1e3, learn_rate = .0001)
#
# nn2 <- nnLayers$new(Species ~ ., data = iris, hidden = 6)
# nn2$train(9999, trace = 1e3, learn_rate = .0001)
#
# nn3 <- nnLayers$new(Species ~ ., data = iris, hidden = 8)
# nn3$train(9999, trace = 1e3, learn_rate = .0001)

compareNN <- function(nn1, nn2){
   plot(nn1$accuracyTime, xlab = "Iterations", ylab = "Accuracy", type = "o", pch =20, col= "blue")
   points(nn2$accuracyTime, col="red", pch=20, type = "o")
   legend("bottomright",
          legend = c("NN1", "NN2"),
          col = c("red", "blue"),
          pch = 20,
          inset = c(0.1, 0.1))
 }

# # Iris
# irisNN1 <- nnCoreV1$new(Species ~ ., data = iris, hidden = 6)
# irisNN1$train(9999, trace = 1e3, learn_rate = .0001)
#
# irisNN2 <- nnCoreV2$new(Species ~ ., data = iris, hidden = 6)
# irisNN2$train(9999, trace = 1e3, learn_rate = .0001)
# compareNN(irisNN1, irisNN2)
# # infertility
# infertNN1 <- nnCoreV1$new(education ~ ., data= infert, hidden = 6)
# infertNN1$train(4000, trace = 1e3, learn_rate = .0001)
#
# infertNN2 <- nnCoreV2$new(education ~ ., data= infert, hidden = 6, plotData = T)
# infertNN2$train(4000, trace = 1e3, learn_rate = .0001)
# compareNN(infertNN1, infertNN2)
#
#
# # Higgs Boson Predciton
# higgsDat <- read.csv("C:/Users/hsamuelson/Desktop/R/Higgs/training/training.csv")
# higgsDat <- higgsDat[,-1]
#
# higgsNN1 <- nnCoreV1$new(Label ~ ., data= higgsDat[1:150,], hidden = 30)
# higgsNN1$train(9999, trace = 1e3, learn_rate = .0001)
#
# higgsNN2 <- nnCoreV2$new(Label ~ ., data= higgsDat[1:150,], hidden = 30, plotData = T)
# higgsNN2$train(9999, trace = 1e3, learn_rate = .0001)
# compareNN(higgsNN1, higgsNN2)
