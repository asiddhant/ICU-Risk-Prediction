#Extracting Features Out of Time Series. In an online manner ie. on the basis of records
#available upto that time. We extracted features - MIN,MAX,AVG,SD
#Also tried using Skewness and AR and MA values but dropped them later as they were not
#significantly important in model and thier calculation also required too much time.


test_labs_feature=matrix(0,nrow=nrow(test_labs),ncol=84)

for(i in 1:nrow(test_age))
{
  test_temp=as.matrix(test_labs[obs_test[i]:(obs_test[i+1]-1),])
  for(l in 1:(obs_test[i+1]-obs_test[i]))
  {
    for(j in 1:21)
    {
      test_labs_feature[(obs_test[i]+l-1),j]=min(test_temp[1:l,j+2])
      test_labs_feature[(obs_test[i]+l-1),j+21]=max(test_temp[1:l,j+2])
      test_labs_feature[(obs_test[i]+l-1),j+42]=mean(test_temp[1:l,j+2])
      test_labs_feature[(obs_test[i]+l-1),j+63]=sd(test_temp[1:l,j+2])
    }
  }
  print(i)
}

test_vitals_feature=matrix(0,nrow=nrow(test_vitals),ncol=24)

for(i in 1:nrow(test_age))
{
  test_temp=as.matrix(test_vitals[obs_test[i]:(obs_test[i+1]-1),])
  for(l in 1:(obs_test[i+1]-obs_test[i]))
  {
    for(j in 1:6)
    {
      test_vitals_feature[(obs_test[i]+l-1),j]=min(test_temp[1:l,j+2])
      test_vitals_feature[(obs_test[i]+l-1),j+6]=max(test_temp[1:l,j+2])
      test_vitals_feature[(obs_test[i]+l-1),j+12]=mean(test_temp[1:l,j+2])
      test_vitals_feature[(obs_test[i]+l-1),j+18]=sd(test_temp[1:l,j+2])
    }
  }
  print(i)
}

train_labs_feature=matrix(0,nrow=nrow(train_labs),ncol=84)

for(i in 1:nrow(train_age))
{
  train_temp=as.matrix(train_labs[obs_train[i]:(obs_train[i+1]-1),])
  for(l in 1:(obs_train[i+1]-obs_train[i]))
  {
    for(j in 1:21)
    {
      train_labs_feature[(obs_train[i]+l-1),j]=min(train_temp[1:l,j+2])
      train_labs_feature[(obs_train[i]+l-1),j+21]=max(train_temp[1:l,j+2])
      train_labs_feature[(obs_train[i]+l-1),j+42]=mean(train_temp[1:l,j+2])
      train_labs_feature[(obs_train[i]+l-1),j+63]=sd(train_temp[1:l,j+2])
    }
  }
  print(i)
}


train_vitals_feature=matrix(0,nrow=nrow(train_vitals),ncol=24)

for(i in 1:nrow(train_age))
{
  train_temp=as.matrix(train_vitals[obs_train[i]:(obs_train[i+1]-1),])
  for(l in 1:(obs_train[i+1]-obs_train[i]))
  {
    for(j in 1:6)
    {
      train_vitals_feature[(obs_train[i]+l-1),j]=min(train_temp[1:l,j+2])
      train_vitals_feature[(obs_train[i]+l-1),j+6]=max(train_temp[1:l,j+2])
      train_vitals_feature[(obs_train[i]+l-1),j+12]=mean(train_temp[1:l,j+2])
      train_vitals_feature[(obs_train[i]+l-1),j+18]=sd(train_temp[1:l,j+2])
    }
  }
  print(i)
}

#Some SD Values were missing as standard deviation is not defined for single data at
#time==0 for each pateint. So we put imputed those records with 0

train_vitals_feature[which(train_vitals$TIME==0),19:24]=0
test_vitals_feature[which(test_vitals$TIME==0),19:24]=0

train_labs_feature[which(train_labs$TIME==0),64:84]=0
test_labs_feature[which(test_labs$TIME==0),64:84]=0

train_labs_feature=as.data.frame(train_labs_feature)
test_labs_feature=as.data.frame(test_labs_feature)

train_vitals_feature=as.data.frame(train_vitals_feature)
test_vitals_feature=as.data.frame(test_vitals_feature)

