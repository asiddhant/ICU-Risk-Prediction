#Loading the Datasets

train_age     = read.csv("id_age_train.csv")
train_labs    = read.csv("id_time_labs_train.csv")
train_vitals  = read.csv("id_time_vitals_train.csv")
train_label   = read.csv("id_label_train.csv")

test_age     = read.csv("id_age_test.csv")
test_labs    = read.csv("id_time_labs_test.csv")
test_vitals  = read.csv("id_time_vitals_test.csv")

#Useful Variables : Keeps Track of Starting Records of all patients and Ending Record of
#Last Pateint
obs_train=which(train_labs$TIME==0)
obs_test=which(test_labs$TIME==0)

obs_train[length(obs_train)+1]=nrow(train_labs)
obs_test[length(obs_test)+1]=nrow(test_labs)

#Imputations in train_labs,and test_labs
#To ensure an online model. We imputed the values with last avaliable values and imputed
#the first record of patients with median of first record of other patients.
#Four Lab Variables L13,L15,L19,L24 Dropped due to Large Number of Missing Values

train_labs<-select(train_labs,-c(L13,L17,L19,L24))
test_labs<-select(test_labs,-c(L13,L17,L19,L24))

combo_labs=rbind(train_labs,test_labs)

combo_temp<-combo_labs[combo_labs$TIME==0,] 
combo_temp<-select(combo_temp,-c(ID,TIME))
combo_zero_median<-apply(as.matrix(combo_temp), 2, FUN = median, na.rm=TRUE)

for(i in 1:21)
{
  combo_temp[is.na(combo_temp[,i]),i]=combo_zero_median[i]
}

combo_labs[which(combo_labs$TIME==0),3:23]=combo_temp

train_labs=head(combo_labs,n=nrow(train_labs))
test_labs=tail(combo_labs,n=nrow(test_labs))

#Removing Temporary Variables from Workspace
rm(combo_temp,combo_labs,combo_zero_median)

train_labs=as.matrix(train_labs)
temp=nrow(train_labs)
for (i in 1:temp)
{
  for (j in 3:23)
  {
    if(is.na(train_labs[i,j]))
      train_labs[i,j]=train_labs[i-1,j]
  }
  print(i)
}
train_labs=as.data.frame(train_labs)

temp=nrow(test_labs)
test_labs=as.matrix(test_labs)
for (i in 1:temp)
{
  for (j in 3:23)
  {
    if(is.na(test_labs[i,j]))
      test_labs[i,j]=test_labs[i-1,j]
  }
  print(i)
}
test_labs=as.data.frame(test_labs)

combo_vitals=rbind(train_vitals,test_vitals)

combo_temp<-combo_vitals[combo_vitals$TIME==0,] 
combo_temp<-select(combo_temp,-c(ID,TIME,ICU))
combo_zero_median<-apply(as.matrix(combo_temp), 2, FUN = median, na.rm=TRUE)

for(i in 1:6)
{
  combo_temp[is.na(combo_temp[,i]),i]=combo_zero_median[i]
}

combo_vitals[which(combo_vitals$TIME==0),3:8]=combo_temp

train_vitals=head(combo_vitals,n=nrow(train_vitals))
test_vitals=tail(combo_vitals,n=nrow(test_vitals))

rm(combo_zero_median,combo_temp,combo_vitals)

train_vitals=as.matrix(train_vitals)
temp=nrow(train_vitals)
for (i in 1:temp)
{
  for (j in 3:8)
  {
    if(is.na(train_vitals[i,j]))
      train_vitals[i,j]=train_vitals[i-1,j]
  }
  print(i)
}
train_vitals=as.data.frame(train_vitals)

temp=nrow(test_vitals)
test_vitals=as.matrix(test_vitals)
for (i in 1:temp)
{
  for (j in 3:8)
  {
    if(is.na(test_vitals[i,j]))
      test_vitals[i,j]=test_vitals[i-1,j]
  }
  print(i)
}
test_vitals=as.data.frame(test_vitals)
