short_train_labs_feature$L2SKW=NULL
short_train_labs_feature$L3SKW=NULL
short_train_labs_feature$L6SKW=NULL
short_train_labs_feature$L12SKW=NULL
short_train_labs_feature$L14SKW=NULL
short_train_labs_feature$L15SKW=NULL
short_train_labs_feature$L16SKW=NULL
short_train_labs_feature$L19SKW=NULL
short_train_labs_feature$L20SKW=NULL
short_train_labs_feature$L21SKW=NULL
short_train_labs_feature$L22SKW=NULL
short_train_labs_feature$L23SKW=NULL
short_train_labs_feature$L24SKW=NULL
short_train_labs_feature$L25SKW=NULL
 

short_train_labs_feature[,64:92]=na.roughfix(short_train_labs_feature[,64:92])

imputer=cbind(short_train_vitals[,c(3,4,5,7)],short_train_vitals_feature[,19:30],short_train_vitals_feat[,c(3,4,5,6)])
imputer=complete(mice(imputer))

