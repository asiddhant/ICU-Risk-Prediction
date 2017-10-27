#Subsetting

train_label_expand = merge(train_vitals,train_label,by="ID")
train_label_expand = merge(train_label_expand,train_age,by="ID")

train_label_expand$ICU_TIME=0
train_label_expand<-as.matrix(train_label_expand)
for(i in 1:nrow(train_label_expand))
{
  icu_flag=train_label_expand[i,9]
  if(train_label_expand[i,2]==0){
    icu_time=0
  }
  else if(icu_flag==1)
    icu_time=icu_time+(train_label_expand[i,2]-train_label_expand[i-1,2])
  train_label_expand[i,12]=icu_time
}
train_label_expand<-as.data.frame(train_label_expand)
rm(icu_flag)
rm(icu_time)

train_label_expand=cbind(train_labs,select(train_label_expand,-c(ID,TIME)))

nobs_train=rep(0,nrow(train_age))
for(i in 1:length(nobs_train))
  nobs_train[i]=obs_train[i+1]-obs_train[i]

nobs_val=rep(0,nrow(val_age))
for(i in 1:length(nobs_val))
  nobs_val[i]=obs_val[i+1]-obs_val[i]

nobs_test=rep(0,nrow(test_age))
for(i in 1:length(nobs_test))
  nobs_test[i]=obs_test[i+1]-obs_test[i]


train_temp=subset(train_label_expand,is.na(train_label_expand$LABEL))
for (i in 1:nrow(subset(train_label,train_label$LABEL==1)))
{
  temp=(train_label_expand$TIME[obs_train[which(train_label$LABEL==1)+1][i]-1])-86400
  for(j in 1:nobs_train[which(train_label$LABEL==1)][i])
  {
    temp2=train_label_expand$TIME[obs_train[which(train_label$LABEL==1)][i]+j-1]
    train_label_expand$LABEL[obs_train[which(train_label$LABEL==1)][i]+j-1]=ifelse(temp2>temp,1,0)
  }
}

rm(train_temp)
