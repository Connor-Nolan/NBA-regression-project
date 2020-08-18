#Read in data from csv

NBA_data<-read.csv("NBA19-20.csv", header=TRUE)
library(dplyr)
NBA_data<-filter(NBA_data, is.na(OT))

#Preview data

head(NBA_data)

#Create new variables

NBA_data$HomePoints<-ifelse(NBA_data$TeamWin==NBA_data$Home, NBA_data$WinPoints, NBA_data$LosePoints)
NBA_data$AwayPoints<-ifelse(NBA_data$TeamWin==NBA_data$Away, NBA_data$WinPoints, NBA_data$LosePoints)
NBA_data$Homeb2b<-ifelse(NBA_data$HomeRest==0, 1, 0)
NBA_data$Awayb2b<-ifelse(NBA_data$AwayRest==0, 1, 0)

#Create model for home points, check summary, assign coefficients to homecoeffAR

Home_Model<-lm(HomePoints~HomeeFG + HomeTOV + HomeOREB + HomeFTR + AwayTOV + AwayOREB + AwayFTR,  data = NBA_Train)
summary(Home_Model)
homecoeffAR<-Home_Model$coeff

#Same thing but for away

Away_Model<-lm(AwayPoints~HomeOREB + HomeFTR + AwayeFG + AwayTOV + AwayOREB + AwayFTR, data = NBA_Train)
summary(Away_Model)
awaycoeffAR<-Away_Model$coeff

#Check to see if it's working correctly

homecoeffAR[8]

#store residuals

NBA_data$homeres<-Home_Model$residuals
NBA_data$awayres<-Away_Model$residuals

#Looking at plots of the model to check assumptions
plot(Home_Model, which = 1:4)

plot(Away_Model, which = 1:4)

#filtering for games where I made a pick beforehand

Picked_games<-filter(NBA_data,NBA_data$Pick!= "")

#creating variables for the results of the game in relation to the point spread

Picked_games$Favorite_cover<-ifelse((Picked_games$Favorite==Picked_games$TeamWin) & (Picked_games$WinPoints - Picked_games$LosePoints >Picked_games$Spread),
                                    T,F)
Picked_games$Push<-ifelse(Picked_games$Favorite==Picked_games$TeamWin & Picked_games$WinPoints - Picked_games$LosePoints ==Picked_games$Spread,
                          T,F)
Picked_games$Dog_cover<-ifelse(Picked_games$Favorite_cover==F & Picked_games$Push==F,T,F)

#Did I predict the game correctly?

Picked_games$Correct<-ifelse((Picked_games$Favorite_cover==T & as.character(Picked_games$Pick)==as.character(Picked_games$Favorite))|(
  Picked_games$Dog_cover==T & as.character(Picked_games$Pick) != as.character(Picked_games$Favorite)
),T,F)
prop.table(table(Picked_games$Correct))

#Function to get projected scores for each team

#x1=homeefg,x2=hometov,x3=homeoreb,x4=homeftr,x5=awayefg,x6=awaytov,x7=awayoreb,x8=awayftr
scorew<-function(x1, x2, x3, x4, x5, x6, x7, x8){
  h<-homecoeffAR[1]+homecoeffAR[2]*x1+homecoeffAR[3]*x2+homecoeffAR[4]*x3+homecoeffAR[5]*x4+0*x5+homecoeffAR[6]*x6+homecoeffAR[7]*x7+homecoeffAR[8]*x8
  a<-awaycoeffAR[1]+0*x1+0*x2+awaycoeffAR[2]*x3+awaycoeffAR[3]*x4+awaycoeffAR[4]*x5+awaycoeffAR[5]*x6+awaycoeffAR[6]*x7+awaycoeffAR[7]*x8
  return(c(h,a,h+a))
}