selected_train_label_expand=select(short_train_label_expand,c(ID,TIME,AGE,ICU_TIME,V1,V2,V3,V5,V6,L1,L2,L4,L5,L6,L8,L11,L12,L15,L20,L21,L22,LABEL))
selected_train_labs_feature=select(short_train_labs_feature,c(L5MIN,L11MIN,L18MIN,L21MIN,L12MAX,L15MAX,L1AVG,L2AVG,L4AVG,L6AVG,L12AVG,L9AVG,L15AVG,L20AVG,L11AVG,L21AVG,L22AVG,L23AVG,L16AVG,L25AVG,L5SD,L15SD,L8SD,L22SD,L12SD,L25SD,L3SD,L9SD,L10SD,L4SD))
selected_train_vitals_feature=select(short_train_vitals_feature,c(V1MIN,V2MIN,V3MIN,V5MIN,V4MAX,V4AVG,V5AVG,V4SD,V5SD,V6SD))
selected_train=cbind(selected_train_label_expand,selected_train_vitals_feature,selected_train_labs_feature)

