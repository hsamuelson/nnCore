library(roxygen2)
#' nnCore
#'
#' A Light Weight Deep Learning Core in R.
#' This library was built to have a simple yet comprehensive neural
#' network library that is well commented. This library was built to
#' be light weight in comparison to most bloated neuralnet libraries.
#' @name nnCore
#' @param nnCore$new(Species ~ ., data = iris, hidden = 6)
#' @keywords neuralnetwork, nnCore
#' @export
#' @examples
#' nn <- nnCore$new(Species ~ ., data = iris, hidden = 6)
#' nn$train(9999, trace = 1e3, learn_rate = .0001)
#' nn$computeNN(iris[,-5])
#'
#' Creating a new Network
#' nn <- nnCore$new(Species ~ ., data = iris, hidden = 6)
#'For the formula Species~. Means that column named “Species” Correlates to . which means the reaming columns in the data set. If you do not want to include all columns in the data set you can name the specific columns separated with “+”s. Species ~ Sepal.Length+Sepal.Width.

#' ## Training A Network
#'nn$train(9999, trace = 1e3, learn_rate = .0001)
#'9999 is the number of training iterations. Default the number of iterations is set to 1e4 or the default tolerance threshold which is 0.01 if the threshold is achived before the set number of iterations is passed.
#'
#' ## Compute New Observations
#'nn$computeNN(iris[,-5])
#'iris[,-5] is simply the iris training set with the class column removed, which will overlap with the dataset, but any new observations can be tested with $computeNN. The function will return the predicted classifications.

#' ## Linking and Predicting
#'The $ syntax of the R6 library allows for commands to be strung together in one line. It is important to note that order does matter.

#'nn$train(9999, trace = 1e3, learn_rate = .0001)$predict(data.matrix(cbind(1, iris[,-5])))
#'Hidden Layer Modifications
#'You can either enter a specific number of hidden nodes or you can put one of three options in as a character, to create a generic number of nodes. This is valuable if you are generating neural networks within a program and do not have time to run a hyperparameters test. These three options have been defined as generic ways of determining an accurate number of hidden nodes. Choose 1,2,3 to decide method for choosing # of hidden nodes.
#'
#'“1”     # of hidden nodes = # of inputnodes
#'“2”     # of hidden nodes = # of (# of input nodes + output nodes)/ (2/3)
#'“3”     # of hidden nodes =  sqrt(# of input nodes * # of attributes)
#' ## Examples
#'This will use option one, which will simply be the number of input nodes

#'nn <- nnCore$new(Species ~ ., data = iris, hidden = "1")

library(R6)
nnCore <- R6Class("NeuralNetwork",
  public = list(
    X = NULL,  Y = NULL,
    W1 = NULL, W2 = NULL,
    output = NULL, accuracyTime = numeric(),
    hiddenSelect = function(hidd){ #w will be Dat
      if(hidd == "1"){
        hiddenMode <- round(length(colnames(data)))
      } else if(hidd == "2"){
        hiddenMode <- round((round(length(colnames(data))) + 1)/(2/3))
      } else if(hidd == "3"){
        hiddenMode <- round(sqrt(length(colnames(data))*  length(data[,1]) ))
      }
      return(hiddenMode)
    },
    # initialize sets up the initial neuralnetwork structure, and generates
    # weights etc.
    initialize = function(formula, hidden, data = list()) {
      # Model and training data
      mod <- model.frame(formula, data = data) #This allows us to use the ~ sintax
      self$X <- model.matrix(attr(mod, 'terms'), data = mod)
      self$Y <- model.response(mod)

      # Dimensions
      D <- ncol(self$X) # input dimensions (+ bias)

      # number of categories for classification
      K <- length(unique(self$Y)) # number of classes
      if(typeof(hidden) == "character"){
        H <- self$hiddenSelect(hidden)  #This allows us to use predetermined hidden node options.
      }else{
        H <- hidden # number of hidden nodes (- bias)
      }
      # Initial weights and bias for the two layers
      self$W1 <- .01 * matrix(rnorm(D * H), D, H)
      self$W2 <- .01 * matrix(rnorm((H + 1) * K), H + 1, K)
    },

    #Fit runs one step of bpropogation but returns the result, instead of storing it,
    #used for predicting new test data.
    fit = function(data = self$X) {
      h <- self$sigmoid(data %*% self$W1)
      score <- cbind(1, h) %*% self$W2
      return(self$softmax(score))
    },
    # runs func fit but saves the results for training.
    # typically this is orginized backwards, but in order to not have to copy
    # feedforward into fit it is setup this way
    feedforward = function(data = self$X) {
      self$output <- self$fit(data)
      invisible(self)
    },
    # Standard backpropgate function
    # saves the training results.
    backpropagate = function(lr = 1e-2) {
      h <- self$sigmoid(self$X %*% self$W1)
      Yid <- match(self$Y, sort(unique(self$Y)))

      haty_y <- self$output - (col(self$output) == Yid) # E[y] - y
      dW2 <- t(cbind(1, h)) %*% haty_y

      dh <- haty_y %*% t(self$W2[-1, , drop = FALSE])
      dW1 <- t(self$X) %*% (self$dsigmoid(h) * dh)

      self$W1 <- self$W1 - lr * dW1
      self$W2 <- self$W2 - lr * dW2

      invisible(self)
    },
    # uses argmax to estamte a single class for each observation. i.e. one
    # test input
    predict = function(data = self$X) {
      probs <- self$fit(data)
      preds <- apply(probs, 1, which.max)
      levels(self$Y)[preds]
    },
    # computes the loss used to report improvments in the neuralnet during training
    # Can also be called through accuracy during prediction() tests
    compute_loss = function(probs = self$output) {
      Yid <- match(self$Y, sort(unique(self$Y)))
      correct_logprobs <- -log(probs[cbind(seq_along(Yid), Yid)])
      sum(correct_logprobs)
    },
    # The main train function think of this as the main() function
    # calls feedforward() and backpropogation() in the correct orders
    train = function(iterations = 1e4,
                     learn_rate = 1e-2,
                     tolerance = .01,
                     trace = 100) {
      for (i in seq_len(iterations)) {
        self$feedforward()$backpropagate(learn_rate)
        self$accuracyTime[i] <- self$accuracy()   #Recording the points every iteration is to slow!

        if (trace > 0 && i %% trace == 0){
          message('Iteration ', i, '\tLoss ', self$compute_loss(),'\tAccuracy ', self$accuracy()) #Print the accuracy and loss
        }
        if (self$compute_loss() < tolerance){ #When the loss is under the tolerance stop training
          break

          }
      }
      invisible(self)
      plot(self$accuracyTime, xlab = "Iterations", ylab = "Accuracy", type = "o", pch =20, col= "red")

    },
    # uses  compute_loss() function to determine the accuracy
    accuracy = function() {
      predictions <- apply(self$output, 1, which.max)
      predictions <- levels(self$Y)[predictions]
      mean(predictions == self$Y)
    },

    # Creates a better interface for the user without interfering with the other uses of predict()
    computeNN = function(data ) {
      self$predict(data.matrix(cbind(1, data)))
    },
    # This function tests and runs a test final accuracy by testing with new data
    # This funciton only uses 80% of the data to train and 20% to test, but in the real algorithm you train
    # it will use 100% of the training data you give it. This insures that with your data you can get the best
    # algorithumn possible.
    nnCoreAccuracy = function(data, columnName) {
      nnAccuracy <- nnCore$new(paste0(columnName, "~."), data = data[1:round(length(data[,1])*.8),], hidden = "1")
      nnAccuracy$train(9999, trace = 1e3, learn_rate = .0001)
      data2 <- data[ , !(names(data) %in% columnName)]
      guesses <- nnAccuracy$computeNN(data2[length(round(data2[,1]*.8)):length(data2[,1]),])
      mean(guesses == data[columnName])
    },
    # larger selection of activation functions to use
    sigmoid = function(x) 1 / (1 + exp(-x)),
    dsigmoid = function(x) x * (1 - x),
    softmax = function(x) exp(x) / rowSums(exp(x))
  )
)
