# nnCore
A Light Weight Deep Learning Core in R

## Description
This library was built to have a simple yet comprehensive neural network library that is well commented. This library was built to be light weight in comparison to most bloated neuralnet libraries.

### Creating a new Network
```
nn <- nnCore$new(Species ~ ., data = iris, hidden = 6)
```
For the formula ```Species~.``` Means that column named “Species” Correlates to ```.``` which means the reaming columns in the data set. If you do not want to include all columns in the data set you can name the specific columns separated with “+”s. ```Species ~ Sepal.Length+Sepal.Width```.
### Training A Network
```
nn$train(9999, trace = 1e3, learn_rate = .0001)
```
9999 is the number of training iterations. Default the number of iterations is set to ```1e4``` or the default tolerance threshold which is ```0.01``` if the threshold is achived before the set number of iterations is passed.
### Compute New Observations
```
nn$computeNN(iris[,-5])
```
```iris[,-5]``` is simply the iris training set with the class column removed, which will overlap with the dataset, but any new observations can be tested with ```$computeNN```. The function will return the predicted classifications.
### Linking and Predicting
The ```$``` syntax of the ```R6``` library allows for commands to be strung together in one line. It is important to note that order does matter.
```
nn$train(9999, trace = 1e3, learn_rate = .0001)$predict(data.matrix(cbind(1, iris[,-5])))
````




