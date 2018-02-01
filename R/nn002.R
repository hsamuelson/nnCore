library(R6)
NeuralNetwork <- R6Class("NeuralNetwork",
  public = list(
    X = NULL,  Y = NULL,
    W1 = NULL, W2 = NULL,
    output = NULL,
    initialize = function(formula, hidden, data = list()) {
      # Model and training data
      mod <- model.frame(formula, data = data)
      self$X <- model.matrix(attr(mod, 'terms'), data = mod)
      self$Y <- model.response(mod)

      # Dimensions
      D <- ncol(self$X) # input dimensions (+ bias)
      K <- length(unique(self$Y)) # number of classes
      H <- hidden # number of hidden nodes (- bias)

      # Initial weights and bias
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

    feedforward = function(data = self$X) {
      self$output <- self$fit(data)
      invisible(self)
    },
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
    predict = function(data = self$X) {
      probs <- self$fit(data)
      preds <- apply(probs, 1, which.max)
      levels(self$Y)[preds]
    },
    compute_loss = function(probs = self$output) {
      Yid <- match(self$Y, sort(unique(self$Y)))
      correct_logprobs <- -log(probs[cbind(seq_along(Yid), Yid)])
      sum(correct_logprobs)
    },
    train = function(iterations = 1e4,
                     learn_rate = 1e-2,
                     tolerance = .01,
                     trace = 100) {
      for (i in seq_len(iterations)) {
        self$feedforward()$backpropagate(learn_rate)
        if (trace > 0 && i %% trace == 0)
          message('Iteration ', i, '\tLoss ', self$compute_loss(),
                  '\tAccuracy ', self$accuracy())
        if (self$compute_loss() < tolerance) break
      }
      invisible(self)
    },
    accuracy = function() {
      predictions <- apply(self$output, 1, which.max)
      predictions <- levels(self$Y)[predictions]
      mean(predictions == self$Y)
    },
    sigmoid = function(x) 1 / (1 + exp(-x)),
    dsigmoid = function(x) x * (1 - x),
    softmax = function(x) exp(x) / rowSums(exp(x))
  )
)
