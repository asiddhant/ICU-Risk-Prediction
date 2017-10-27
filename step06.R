#Reducing the Training Data

short_train_label_expand <- data.frame()
short_train_vitals_feature <- data.frame()
short_train_labs_feature <-data.frame()

for (i in 1:nrow(train_labs))
{
  if(train_labs[i,2]==0){
    curr_id=train_labs[i,1]
    temp1<-train_labs[which(train_labs$ID==curr_id),]
    temp2<-train_label_expand[which(train_labs$ID==curr_id),]
    temp3<-train_vitals_feature[which(train_labs$ID==curr_id),]
    temp4<-train_vitals_feat[which(train_labs$ID==curr_id),]
    indexer<-NULL
    nrecords=nrow(temp1)
  if(nrecords>1)
      indexer<-seq(from=round(2*log(nrecords)),to=nrecords-1,by=round(2*log(nrecords)))
    indexer<-c(1,indexer,nrecords)
  
    temp2<-temp2[indexer,]
    temp3<-temp3[indexer,]
    temp4<-temp4[indexer,]
    short_train_label_expand <- rbind(short_train_label_expand,temp2)
    short_train_vitals_feature <- rbind(short_train_vitals_feature,temp3)
    short_train_labs_feature <-rbind(short_train_labs_feature,temp4)
    i=i+nrecords
  }
}

rm(temp1,temp2,temp3,temp4,temp5,temp6,i,curr_id,nrecords,indexer,train_label_expand,train_labs_feature,train_vitals_feature,train_vitals_feat,train_vitals,train_labs)





