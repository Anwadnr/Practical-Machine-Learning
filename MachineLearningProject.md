Background
==========

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now
possible to collect a large amount of data about personal activity
relatively inexpensively. In this project, my goal will be to use data
from accelerometers on the belt, forearm, arm, and dumbell of 6
participants. They were asked to perform barbell lifts correctly and
incorrectly in 5 different ways. More information is available from the
website here: <http://groupware.les.inf.puc-rio.br/har>

Data
====

Training data:
<https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv>

Test data:
<https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv>

The data for this project come from this source:
<http://groupware.les.inf.puc-rio.br/har>.

Summary of Technique
--------------------

In order to accomplish the goal of this project the data will be loaded,
cleaned and explored to discover structure and summary statistics. Once
preliminary diagnostics and setup are complete, the seed will be set at
1234. In order to ensure accuracy and cross validate results the data
will be partitioned and subsampled to accomidate test and train data set
models. Once both the decision tree model and rand forest model are
complete the accuracy will be compaired and final decision will be made
on which model to use.

Loading Libraries then exploring and cleaning data

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

Cleaning and partitioning data for use in models by creating 2 subsets
of the training set.

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

Prediction Model: Decision Tree
===============================

Creating and Plotting the Decision Tree

    pred_model <- rpart(classe ~ ., data = train_set, method ="class")

    rpart.plot(pred_model, main = "Classification Tree", 
               extra = 102, under = TRUE, faclen = 0)

![](MachineLearningProject_files/figure-markdown_strict/Classification%20Tree-1.png)

Testing Results

    mod_pred <- predict(pred_model, test_set, type = "class")

    confusionMatrix(mod_pred, test_set$classe)

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1235  157   16   50   20
    ##          B   55  568   73   80  102
    ##          C   44  125  690  118  116
    ##          D   41   64   50  508   38
    ##          E   20   35   26   48  625
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.7394          
    ##                  95% CI : (0.7269, 0.7516)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.6697          
    ##  Mcnemar's Test P-Value : < 2.2e-16       
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            0.8853   0.5985   0.8070   0.6318   0.6937
    ## Specificity            0.9307   0.9216   0.9005   0.9529   0.9678
    ## Pos Pred Value         0.8356   0.6469   0.6313   0.7247   0.8289
    ## Neg Pred Value         0.9533   0.9054   0.9567   0.9296   0.9335
    ## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
    ## Detection Rate         0.2518   0.1158   0.1407   0.1036   0.1274
    ## Detection Prevalence   0.3014   0.1790   0.2229   0.1429   0.1538
    ## Balanced Accuracy      0.9080   0.7601   0.8537   0.7924   0.8307

Prediction Model: Random Forest
===============================

Running Randomn Forest

    ran_for <- randomForest(classe ~. , data = train_set)

Testing Results

    for_pred <- predict(ran_for, test_set, type = "class", method="class")

    confusionMatrix(for_pred, test_set$classe)

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction    A    B    C    D    E
    ##          A 1395    3    0    0    0
    ##          B    0  943   10    0    0
    ##          C    0    3  844    5    0
    ##          D    0    0    1  799    0
    ##          E    0    0    0    0  901
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.9955          
    ##                  95% CI : (0.9932, 0.9972)
    ##     No Information Rate : 0.2845          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.9943          
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: A Class: B Class: C Class: D Class: E
    ## Sensitivity            1.0000   0.9937   0.9871   0.9938   1.0000
    ## Specificity            0.9991   0.9975   0.9980   0.9998   1.0000
    ## Pos Pred Value         0.9979   0.9895   0.9906   0.9988   1.0000
    ## Neg Pred Value         1.0000   0.9985   0.9973   0.9988   1.0000
    ## Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
    ## Detection Rate         0.2845   0.1923   0.1721   0.1629   0.1837
    ## Detection Prevalence   0.2851   0.1943   0.1737   0.1631   0.1837
    ## Balanced Accuracy      0.9996   0.9956   0.9926   0.9968   1.0000

Which Model to Use?
===================

The Random Forest model performed better than Decision Tree model. The
Decision Tree model accuracy was 0.739 (95% CI: (0.727, 0.752)) where
the Random Forest model was 0.995 (95% CI: (0.993, 0.997)). The Random
Forest model will be used to test.

Submission
==========

    test_set_pred <- predict(ran_for, test, type="class")
    test_set_pred

    ##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
    ##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
    ## Levels: A B C D E
