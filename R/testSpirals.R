
#Taken from:
#https://github.com/Selbosh/selbosh.github.io/blob/source/content/post/2018-01-09-neural-network.Rmd
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
testData <- two_spirals(labels = c('class 1', 'class 2'))

#
# DEMO TEST DATA BELOW IF WANTED
#
#x <- data.matrix(testData[, c('x1', 'x2')])
#y <- hotdogs$class == 'class 1'

#nnet5 <- train(allData = iris, columnId = "Species", classification = "Virginica", hidden = 5, iterations = 1e5)
#mean((nnet5$output > .5) == y) #find accuracy
