
# Background

# Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. In this project, my goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. 
# More information is available from the website here: http://groupware.les.inf.puc-rio.br/har 

# Data

# Training data: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv
 
# Test data: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv
 
# The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har.
 
## Summary of Technique 
# In order to accomplish the goal of this project the data will be loaded, cleaned and explored to discover structure and summary statistics. Once preliminary diagnostics and setup are complete, the seed will be set at 1234. In order to ensure accuracy and cross validate results the data will be partitioned and subsampled to accomidate test and train data set models. Once both the decision tree model and rand forest model are complete the accuracy will be compaired and final decision will be made on which model to use.
 
# Loading Libraries then exploring and cleaning data


library(dplyr)
library(caret)
library(rpart.plot)
library(randomForest)
library(e1071)

train <- read.csv("pml-training.csv", na.strings=c("NA","#DIV/0!", ""))
test <- read.csv("pml-testing.csv", na.strings=c("NA","#DIV/0!", ""))

summary(train) 
summary(test) 
str(train) 
str(test)

#Cleaning and partitioning data for use in models by creating 2 subsets of the training set.

set.seed(1234)

# Removing all columns with NAs
train <-train[,colSums(is.na(train)) == 0]
test <-test[,colSums(is.na(test)) == 0]

# Removing extraneous columns for simplicity
train <-train[,-c(1:7)]
test <-test[,-c(1:7)]

# Partitioning data
training_set <- createDataPartition(y=train$classe, p=0.75, list=FALSE)
train_set <- train[training_set, ] 
test_set <- train[-training_set, ]



# Prediction Model: Decision Tree

# Creating and Plotting the Decision Tree

pred_model <- rpart(classe ~ ., data = train_set, method ="class")

rpart.plot(pred_model, main = "Classification Tree", 
           extra = 102, under = TRUE, faclen = 0)


# Testing Results

mod_pred <- predict(pred_model, test_set, type = "class")

confusionMatrix(mod_pred, test_set$classe)

# Prediction Model: Random Forest

# Running Randomn Forest

ran_for <- randomForest(classe ~. , data = train_set)

# Testing Results

for_pred <- predict(ran_for, test_set, type = "class", method="class")

confusionMatrix(for_pred, test_set$classe)


# Which Model to Use?
#The Random Forest model performed better than Decision Tree model.
#The Decision Tree model accuracy was 0.739 (95% CI: (0.727, 0.752)) where the Random Forest model was 0.995 (95% CI: (0.993, 0.997)).
#The Random Forest model will be used to test. 

# Submission

test_set_pred <- predict(ran_for, test, type="class")
test_set_pred


