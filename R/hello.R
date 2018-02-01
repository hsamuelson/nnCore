# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

hello <- function() {
  print("Hello, world!")
}
two_spirals <- function(N = 200,
                        radians = 3*pi,
                        theta0 = pi/2,
                        labels = 0:1) {
  N1 <- floor(N / 2)
  N2 <- N - N1

  theta <- theta0 + runif(N1) * radians
  spiral1 <- cbind(-theta * cos(theta) + runif(N1),
                   theta * sin(theta) + runif(N1))
  spiral2 <- cbind(theta * cos(theta) + runif(N2),
                   -theta * sin(theta) + runif(N2))

  points <- rbind(spiral1, spiral2)
  classes <- c(rep(0, N1), rep(1, N2))

  data.frame(x1 = points[, 1],
             x2 = points[, 2],
             class = factor(classes, labels = labels))
}
set.seed(42)
hotdogs <- two_spirals(labels = c('class 1', 'class 2'))


library(ggplot2)
theme_set(theme_classic())
ggplot(hotdogs) +
  aes(x1, x2, colour = class) +
  geom_point() +
  labs(x = expression(x[1]),
       y = expression(x[2]))



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

train <- function(allData, columnId = 1, classification = 0,
hidden = 5,
learn_rate = 1e-2,
iterations = 1e4) {
  if(classification == 0){return("No Class spesified. ERROR")}
  if(typeof(classification) != "charater"){return("Needs a charater value to continue")}


  #allow users to both input a column name or a column value for the column index
  #Then remove the one column of y from the rest of the data.
  if(typeof(columnId) == "character"){
    y <- allData[columnId] == classification
    x <- allData[ , -which(names(allData) %in% c(columnId))]
  } else if(typeof(columnId) == "double"){
    y <- allData[columnId,] == classification
    x <- allData[-columnId]
  }

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
x <- data.matrix(hotdogs[, c('x1', 'x2')])
y <- hotdogs$class == 'class 1'




#nnet5 <- train(x, y, hidden = 5, iterations = 1e5)
#mean((nnet5$output > .5) == y)


#ggplot(hotdogs) + aes(x1, x2, colour = class) + geom_point(data = grid, size = .5) + geom_point() + labs(x = expression(x[1]), y = expression(x[2]))

