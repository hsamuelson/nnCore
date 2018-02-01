#
# Henry Samuelson 1/29/18
#
# A compact core for single-class classifcation, neural networks.
# Built to better my understanding, and to provide a simple, well
# commented neural network library for anyone to understand.
#
# *Muiltiple Hidden layers coming soon!*

hotdogs <- two_spirals(labels = c('class 1', 'class 2'))


# library(ggplot2)
# theme_set(theme_classic())
# ggplot(hotdogs) +
#   aes(x1, x2, colour = class) +
#   geom_point() +
#   labs(x = expression(x[1]),
#        y = expression(x[2]))



sigmoid <- function(x) {1 / (1 + exp(-x))}

feedforward <- function(x, w1, w2) {
  z1 <- cbind(1, x) %*% w1 #generate the x dot product of weights with values
  h <- sigmoid(z1)
  z2 <- cbind(1, h) %*% w2 #hidden layer generation
  list(output = sigmoid(z2), h = h)
}

backpropagate <- function(x, y, y_hat, w1, w2, h, learn_rate) {
  dw2 <- t(cbind(1, h)) %*% (y_hat - y)
  dh  <- (y_hat - y) %*% t(w2[-1, , drop = FALSE])
  dw1 <- t(cbind(1, x)) %*% (h * (1 - h) * dh)

  w1 <- w1 - learn_rate * dw1
  w2 <- w2 - learn_rate * dw2

  list(w1 = w1, w2 = w2)
}

train <- function(allData,
                  columnId = 1,
                  classification = 0,
                  hidden = 5,
                  learn_rate = 1e-2,
                  iterations = 1e4) {

  #Preliminary Checks
  if(classification == 0){return("No Class spesified. ERROR")}
  if(typeof(classification) != "character"){return("Needs a character value to continue")}

  #Becasue this can only handle two class problems right now, we need to remove all rows that are not part of the
  #binary system, here:

  #ADD CODE TO FIX BAD SYSTEM

  #allow users to both input a column name or a column value for the column index
  #Then remove the one column of y from the rest of the data.
  if(typeof(columnId) == "character"){
    y <- allData[columnId] == classification
    x <- allData[ , -which(names(allData) %in% c(columnId))]
  } else if(typeof(columnId) == "double"){
    y <- allData[columnId,] == classification
    x <- allData[-columnId]
  }
  x <- data.matrix(x)
  d <- length(x[1,]) + 1
  w1 <- matrix(rnorm(d * hidden), d, hidden) #Initilized randomized weights for first layer

  w2 <- as.matrix(rnorm(hidden + 1))

  #should change to a foreach? or would run into a recursive issue?
  for (i in 1:iterations) {
    ff <- feedforward(x, w1, w2)
    bp <- backpropagate(x, y,y_hat = ff$output,w1, w2,h = ff$h,learn_rate = learn_rate)
    w1 <- bp$w1
    w2 <- bp$w2
  }
  list(output = ff$output, w1 = w1, w2 = w2)
}







