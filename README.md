# nnCore
A Light Weight Deep Learning Core in R

## Description
This library was built to have a simple yet comprehensive neural network library that is well commented. This library was built to be light weight in comparison to most full-featured neuralnet libraries.
### Installation 
First install devtools. Then install roxygen2 which is used to compile documentation for the library. 
```
install.packages("devtools")
install.packages("roxygen2")
```

Then install the package from github
```install_github("hsamuelson/nnCore")```
### Creating a new Network
```
nn <- nnCoreV2$new(Species ~ ., data = iris, hidden = 6)
```
Using standard R notation for formulas, the formula ```Species~.``` means that the algorithm should analyze the correlation between  the column named “Species” and “.” which means the remaining columns in the data set.If you do not want to include all columns in the data set you can name the specific columns separated with “+”s. ```Species ~ Sepal.Length+Sepal.Width```. There are two versions of nnCore, ```nnCoreV1``` and ```nnCoreV2```. nnCoreV1 is stable and well tested, whereas nnCoreV2 is a development, version where the accuracy will often be higher but may not work in every situtation.
### Training A Network
```
nn$train(9999, trace = 1e3, learn_rate = .0001)
```
9999 is the number of training iterations. Default the number of iterations is set to ```1e4``` or the default tolerance threshold which is ```0.01``` if the threshold is achived before the set number of iterations is passed.
### Plotting Learning Rates
To plot the accuracy of your neuralnetwork overtime is simple. For any of this to work, one must first set the ```plotData``` parameter to ```T```. This will slow down the training process slightly but will record the accuracy and loss while training. Use ``` nn$plotNN()``` to plot the accuracy, in training. To compare two neural nets training accuracy, one can use ```compareNN(NN1, NN2)``` to overlaying plots. This function is important for optimization of neural nets because it allows one to compare training efficiency to previous versions after making changes.

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

### Hidden Layer Modifications
You can either enter a specific number of hidden nodes or you can put one of three options in as a character, to create a generic number of nodes. This is valuable if you are generating neural networks within a program and do not have time to run a hyperparameters test. These three options have been defined as generic ways of determining an accurate number of hidden nodes. 
Choose 1,2,3 to decide method for choosing # of hidden nodes.

     “1”     # of hidden nodes = # of inputnodes 
     “2”     # of hidden nodes = # of (# of input nodes + output nodes)/ (2/3)
     “3”     # of hidden nodes =  sqrt(# of input nodes * # of attributes)

#### Examples
This will use option one, which will simply be the number of input nodes
```
nn <- nnCore$new(Species ~ ., data = iris, hidden = "1")
```
### How It Works 
For an indepth approach to how this library was built please read:

### Function List
#### $hiddenSelect()
contains preset defaults for determining the number of hidden nodes.
#### $new()
sets up the initial neural network structure, and generates weights etc.
#### $fit()
runs one step of back propagation but returns the result, instead of storing it. It is used for predicting new test data.
#### $feedforward()
runs function ```$fit``` but saves the results for training. Typically, this is organized backwards, but in order to not have to copy feedforward into fit it is setup this way.
#### $backpropagate()
preforms generic backpropagation. 
#### $predict()
uses argmax to estimate a single class for each observation. i.e. one test input.
#### $compute_loss()
computes the loss is used to report improvements in the neural net during training. It can also be called through accuracy during prediction() tests.
#### $train()
takes user input for training neural net. This is discussed in the training section. 
#### $accuracy()
uses  ```compute_loss()``` function to determine the accuracy.
#### $computeNN()
Creates a better interface for the user without interfering with the other uses of ```predict()```.
#### $plotNN()
takes user input and is discussed in the plotting section.


