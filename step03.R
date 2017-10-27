#Naming the variables in the data Frames

names(train_labs_feature)=c("L1MIN","L2MIN","L3MIN","L4MIN","L5MIN","L6MIN","L7MIN",
                            "L8MIN","L9MIN","L10MIN","L11MIN","L12MIN","L14MIN",
                            "L15MIN","L16MIN","L18MIN","L20MIN","L21MIN",
                            "L22MIN","L23MIN","L25MIN",
                            "L1MAX","L2MAX","L3MAX","L4MAX","L5MAX","L6MAX","L7MAX",
                            "L8MAX","L9MAX","L10MAX","L11MAX","L12MAX","L14MAX",
                            "L15MAX","L16MAX","L18MAX","L20MAX","L21MAX",
                            "L22MAX","L23MAX","L25MAX",
                            "L1AVG","L2AVG","L3AVG","L4AVG","L5AVG","L6AVG","L7AVG",
                            "L8AVG","L9AVG","L10AVG","L11AVG","L12AVG","L14AVG",
                            "L15AVG","L16AVG","L18AVG","L20AVG","L21AVG",
                            "L22AVG","L23AVG","L25AVG",
                            "L1SD","L2SD","L3SD","L4SD","L5SD","L6SD","L7SD",
                            "L8SD","L9SD","L10SD","L11SD","L12SD","L14SD",
                            "L15SD","L16SD","L18SD","L20SD","L21SD",
                            "L22SD","L23SD","L25SD")

names(train_vitals_feature)=c("V1MIN","V2MIN","V3MIN","V4MIN","V5MIN","V6MIN",
                              "V1MAX","V2MAX","V3MAX","V4MAX","V5MAX","V6MAX",
                              "V1AVG","V2AVG","V3AVG","V4AVG","V5AVG","V6AVG",
                              "V1SD","V2SD","V3SD","V4SD","V5SD","V6SD")

names(test_labs_feature)=c("L1MIN","L2MIN","L3MIN","L4MIN","L5MIN","L6MIN","L7MIN",
                           "L8MIN","L9MIN","L10MIN","L11MIN","L12MIN","L14MIN",
                           "L15MIN","L16MIN","L18MIN","L20MIN","L21MIN",
                           "L22MIN","L23MIN","L25MIN",
                           "L1MAX","L2MAX","L3MAX","L4MAX","L5MAX","L6MAX","L7MAX",
                           "L8MAX","L9MAX","L10MAX","L11MAX","L12MAX","L14MAX",
                           "L15MAX","L16MAX","L18MAX","L20MAX","L21MAX",
                           "L22MAX","L23MAX","L25MAX",
                           "L1AVG","L2AVG","L3AVG","L4AVG","L5AVG","L6AVG","L7AVG",
                           "L8AVG","L9AVG","L10AVG","L11AVG","L12AVG","L14AVG",
                           "L15AVG","L16AVG","L18AVG","L20AVG","L21AVG",
                           "L22AVG","L23AVG","L25AVG",
                           "L1SD","L2SD","L3SD","L4SD","L5SD","L6SD","L7SD",
                           "L8SD","L9SD","L10SD","L11SD","L12SD","L14SD",
                           "L15SD","L16SD","L18SD","L20SD","L21SD",
                           "L22SD","L23SD","L25SD")

names(test_vitals_feature)=c("V1MIN","V2MIN","V3MIN","V4MIN","V5MIN","V6MIN",
                             "V1MAX","V2MAX","V3MAX","V4MAX","V5MAX","V6MAX",
                             "V1AVG","V2AVG","V3AVG","V4AVG","V5AVG","V6AVG",
                             "V1SD","V2SD","V3SD","V4SD","V5SD","V6SD")

#Creating a new data frame containing all labs and vitals records togther along with age
#Age at all times is assumed to be same.
#ICU_TIME is a variable which keeps count of Time for which patient has been in ICU upto
#that time
#Since the Labels for the training dataset was given only at last time stamp. The labels
#were expanded for each time such that those patients for which final label was 0 were given
#label 0 at each time. While those patients who had label 1 were given label 1 48 hours
#before their time of death and remaining were put 0.
#This was done to ensure median prediction time remains good.

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

nobs_train=rep(0,nrow(train_age))
for(i in 1:length(nobs_train))
  nobs_train[i]=obs_train[i+1]-obs_train[i]

for (i in 1:nrow(subset(train_label,train_label$LABEL==1)))
{
  temp=(train_label_expand$TIME[obs_train[which(train_label$LABEL==1)+1][i]-1])-172800
  for(j in 1:nobs_train[which(train_label$LABEL==1)][i])
  {
    temp2=train_label_expand$TIME[obs_train[which(train_label$LABEL==1)][i]+j-1]
    train_label_expand$LABEL[obs_train[which(train_label$LABEL==1)][i]+j-1]=ifelse(temp2>temp,1,0)
  }
}

train_label_expand=cbind(train_labs,select(train_label_expand,-c(ID,TIME)))


test_label_expand = merge(test_vitals,test_age,by="ID")

test_label_expand$ICU_TIME=0
test_label_expand<-as.matrix(test_label_expand)
for(i in 1:nrow(test_label_expand))
{
  icu_flag=test_label_expand[i,9]
  if(test_label_expand[i,2]==0){
    icu_time=0
  }
  else if(icu_flag==1)
    icu_time=icu_time+(test_label_expand[i,2]-test_label_expand[i-1,2])
  test_label_expand[i,11]=icu_time
}
test_label_expand<-as.data.frame(test_label_expand)
rm(icu_flag)
rm(icu_time)

test_label_expand=cbind(test_labs,select(test_label_expand,-c(ID,TIME)))


#We need to shorten the training data. It would take years If we use all the observations. So We came up with a way to
#shorten the training data by retaining adeqaute records for each patient.

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

selected_train_label_expand=select(short_train_label_expand,c(ID,TIME,AGE,ICU_TIME,V1,V2,V3,V5,V6,L1,L2,L4,L5,L6,L8,L11,L12,L15,L20,L21,L22,LABEL))
selected_train_labs_feature=select(short_train_labs_feature,c(L5MIN,L11MIN,L18MIN,L21MIN,L12MAX,L15MAX,L1AVG,L2AVG,L4AVG,L6AVG,L12AVG,L9AVG,L15AVG,L20AVG,L11AVG,L21AVG,L22AVG,L23AVG,L16AVG,L25AVG,L5SD,L15SD,L8SD,L22SD,L12SD,L25SD,L3SD,L9SD,L10SD,L4SD))
selected_train_vitals_feature=select(short_train_vitals_feature,c(V1MIN,V2MIN,V3MIN,V5MIN,V4MAX,V4AVG,V5AVG,V4SD,V5SD,V6SD))
selected_train=cbind(selected_train_label_expand,selected_train_vitals_feature,selected_train_labs_feature)

selected_test_label_expand=select(test_label_expand,c(ID,TIME,AGE,ICU_TIME,V1,V2,V3,V5,V6,L1,L2,L4,L5,L6,L8,L11,L12,L15,L20,L21,L22))
selected_test_labs_feature=select(test_labs_feature,c(L5MIN,L11MIN,L18MIN,L21MIN,L12MAX,L15MAX,L1AVG,L2AVG,L4AVG,L6AVG,L12AVG,L9AVG,L15AVG,L20AVG,L11AVG,L21AVG,L22AVG,L23AVG,L16AVG,L25AVG,L5SD,L15SD,L8SD,L22SD,L12SD,L25SD,L3SD,L9SD,L10SD,L4SD))
selected_test_vitals_feature=select(test_vitals_feature,c(V1MIN,V2MIN,V3MIN,V5MIN,V4MAX,V4AVG,V5AVG,V4SD,V5SD,V6SD))
selected_test=cbind(selected_test_label_expand,selected_test_vitals_feature,selected_test_labs_feature)

selected_test=subset(selected_test,test_vitals$ICU==1)

#Now Apart From selected_train and selected_test we do not need any data. So its wise to keep Only These two datasets in
#the working Environment.

rm(list=ls()[!(ls() %in% c('selected_train','selected_test'))])