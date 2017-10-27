#Before Running this R Script Make Sure Your current directory contains the following

#--"id_time_vitals_train.csv"
#--"id_time_vitals_test.csv"

#--"id_time_labs_train.csv"
#--"id_time_labs_test.csv"

#--"id_age_train.csv"
#--"id_age_test.csv"

#--"id_labels_train.csv"

#We used validation data only for validation purposes and not for training and hence we
#donot require it here. This Code only trains the models on training dataset and performs
#prediction on test dataset.

#This code doesnt have the procedure for selecting variables, which we did manually
#after variable study and by buliding several temporary models and extracting variable
#importance from them. 

#We used caret package for training and used models like logistic
#regression,classification trees, random Forest and stochastic boosted trees. The Random
#Forest and Stochastic boosted did very well on validation sets and so we are including
#only those models in this file ie. randomForest and stochastic boosted trees. We used 
#repeated cross validation on training sets during the training to ensure that the model
#generalises well on unseen data.

#On Validation Dataset, Random Forest came up with a score of 0.39 and Boosted Trees came
#up with a score of 0.40

#Finally After Making TWo Submissions We chose random Forest Model as it was giving 
#better scores on test_data ie 0.36, while boosted tree was giving 0.33.

#Stochastic Boosted Trees and Random Forest are Costly Models and took a lot of time for
#training. Reproducibility of results cannot be gauranteed as the model picks samples at
#random even after setting seet and also depends upon the operaring system and other
#system specifications.We thought of uploading the R data containg model but it requires 
#lots of space and hence could not be uploaded

#This code requires the following CRAN Packages

#Package Installation
install.packages("caret")
install.packages("rpart")
install.packages("randomForest")
install.packages("ada")
install.packages("plyr")
install.packages("dplyr")

#Loading Packages
library(caret)
library(rpart)
library(randomForest)
library(ada)
library(plyr)
library(dplyr)

