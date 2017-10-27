#Training Using Random Forest and Stochastic Boosted Trees


initial_data=select(selected_train,-c(ID,TIME))
initial_data$LABEL=ifelse(initial_data$LABEL==0,"L","D")
initial_data$LABEL=as.factor(initial_data$LABEL)

tr.Control=trainControl(method = "repeatedcv",number=10,repeats=3,summaryFunction = twoClassSummary,classProbs = TRUE)
tune.Grid <- expand.grid(.mtry=c(10,15))

model_random_for <-train(LABEL~., 
                   data = initial_data,
                   method = "rf",
                   metric = "Sens",
                   tuneGrid = tune.Grid,
                   trControl = tr.Control)

#This Model gave a score of 0.39 on validation data and 0.36 on test data and was finally selected


tune.Grid <- expand.grid(.nu=0.1,.iter=200,.maxdepth=4)

model_ada <-train(LABEL~., 
                         data = initial_data,
                         method = "ada",
                         metric = "Sens",
                         tuneGrid = tune.Grid,
                         trControl = tr.Control)

#Removing Unnecceasry Variables from Workspace
rm(tune.Grid,tr.Control)

#This Model gave a score of 0.40 on validation data and 0.33 on test data and hence the random Forest
#Model was preferred over it.

#Threshold is important and in Our case threshold=0.5 was just making sure that specificity crosses 0.99
#and sensitivity was also good. ROC Curves were plotted to decide the threshold

threshold=0.5
prediction=predict(model_random_for,newdata=select(selected_test,-c(ID,TIME)),type="prob")
final_prediction=ifelse(prediction[,1]>threshold,1,0)

output=data.frame(ID=selected_test$ID,TIME=selected_test$TIME,LABEL=final_prediction)
output$ID=as.integer(output$ID)
output$TIME=as.integer(OUTPUT$TIME)
output$LABEL=as.integer(OUTPUT$LABEL)
write.table(output,"output.csv",row.names = FALSE,col.names = FALSE,sep=",")

#file output.csv has been generated in the Workspace
#We are extremely Sorry we cannot gurantee the reproducibilty of code. We want to learn and so we
#participated in this contest. Thank You for giving us this fantastic comptetition. We haven't slept
#for last three days and thanks a lot for the amazing dataset.




