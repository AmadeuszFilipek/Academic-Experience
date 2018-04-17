

data.1 <- read.csv( "C:/Amadeusz_all_files/pakiet_R/sprawozdanie_2/WIOS/PM10.2014a-gios-pjp-data.csv", skip = 2,
                    header = FALSE, stringsAsFactors = F )
data.2 <- read.csv( "C:/Amadeusz_all_files/pakiet_R/sprawozdanie_2/WIOS/PM10.2014b-gios-pjp-data.csv", skip = 2,
                    header = F, stringsAsFactors = F )
data.3 <- read.csv( "C:/Amadeusz_all_files/pakiet_R/sprawozdanie_2/WIOS/PM10.2015a-gios-pjp-data.csv", skip = 2,
                    header = F, stringsAsFactors = F )
data.4 <- read.csv( "C:/Amadeusz_all_files/pakiet_R/sprawozdanie_2/WIOS/PM10.2015b-gios-pjp-data.csv", skip = 2,
                    header = F, stringsAsFactors = F )
data.5 <- read.csv( "C:/Amadeusz_all_files/pakiet_R/sprawozdanie_2/WIOS/PM10.2016-gios-pjp-data.csv", skip = 2,
                    header = F, stringsAsFactors = F )
KRK.data <- rbind( data.1, data.2, data.3, data.4, data.5 )
rm( list  = ls(pattern = "data\\.[[:digit:]]") )
names( KRK.data ) <- c( "date" , "Aleje" , "Bujaka", "Bulwarowa")
KRK.data <- na.omit( KRK.data )

library(lubridate)
KRK.data$date <- as.POSIXct( strptime(KRK.data$date, format ="%Y-%m-%d %H:%M" , tz = "CET" ))
KRK.data$date <- KRK.data$date - 3600
KRK.data <- KRK.data[order( KRK.data$date),]
KRK.data <- KRK.data [ KRK.data$date >= ISOdate(2014,01,01,00, tz = "CET"), ]



########################################## zadanie 1 #####################################
library( lattice )
plot.1 <- xyplot( Aleje ~ date, data = KRK.data, 
        type = "l", lwd = 2, col = "red" , xaxt = 'n', ann = FALSE, 
        main = "Aleje",
        xlab = "", ylab = "PM.10 [ug/m3]" , 
        scales = list( x = list( format = "%Y-%m-%d"),
                       par.settings = simpleTheme( col = c("red", "green", "blue")))
        )

plot.2 <- xyplot( Bujaka ~ date, data = KRK.data, 
                  type = "l", lwd = 2, main = "Bujaka", col = "Green",
                  xlab = "", ylab = "PM.10 [ug/m3]",
                  scales = list( x = list( format = "%Y-%m-%d"),
                                 par.settings = simpleTheme( col = c("red", "green", "blue")))
)
plot.3 <- xyplot( Bulwarowa ~ date, data = KRK.data, 
                  type = "l", lwd = 2, col = "Blue", main = "Bulwarowa",
                  xlab = "", ylab = "PM.10 [ug/m3]",
                  scales = list( x = list( format = "%Y-%m-%d"),
                                 par.settings = simpleTheme( col = c("red", "green", "blue")))
)

png(filename="C:/Amadeusz_all_files/Pakiet_R/sprawozdanie_2/WIOS/plocik.jpg" , width = 1000, height = 1500 )
print( plot.1 , split=c(1,1,1,3), more = TRUE )
print( plot.2 , split=c(1,2,1,3), more = TRUE )
print( plot.3 , split=c(1,3,1,3), more = FALSE )
dev.off()

max(KRK.data$Aleje, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Aleje == max(KRK.data$Aleje, na.rm = TRUE) ] )
min(KRK.data$Aleje, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Aleje == min(KRK.data$Aleje, na.rm = TRUE) ] )

max(KRK.data$Bujaka, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Bujaka == max(KRK.data$Bujaka, na.rm = TRUE) ] )
min(KRK.data$Bujaka, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Bujaka == min(KRK.data$Bujaka, na.rm = TRUE) ] )

min(KRK.data$Bulwarowa, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Bulwarowa == min(KRK.data$Bulwarowa, na.rm = TRUE) ] )
max(KRK.data$Bulwarowa, na.rm = TRUE) 
na.omit( KRK.data$date[ KRK.data$Bulwarowa == max(KRK.data$Bulwarowa, na.rm = TRUE) ] )

################################## zadanie 2 #######################

KRK.month.avg <- timeAverage( KRK.data, avg.time = "month" )

plot.4 <- xyplot( Aleje+Bujaka+Bulwarowa ~ date, data = KRK.month.avg, 
                  type = "l", lwd = 2, col = c("red", "green", "blue") , fontsize=30, 
                  key=list(corner = c(0.9,0.9) ,lines=list(col=c("red", "green", "blue")),
                           text=list(c("Aleje","Bujaka","Bulwarowa"), fontsize=40),fontsize=40),
                  xlab = "", ylab = "PM.10 [ug/m3]",
                  scales = list( x = list( format = "%Y-%m-%d"),
                                 par.settings = simpleTheme( col = c("red", "green", "blue"))               
                  )
)
png(filename="C:/Amadeusz_all_files/Pakiet_R/sprawozdanie_2/WIOS/plociq.jpg" , width = 1000, height = 800 )
print(plot.4)
dev.off()

#################################3 zadanie 3 ####################################

KRK.year.avg <- timeAverage( KRK.data, avg.time = "year" )

N.dni.roku <- length( KRK.data$date[ year(KRK.data$date) == 2016] )
day(KRK.temp$date)
KRK.temp.2014 <- KRK.data[year(KRK.data$date) == 2014, ]
KRK.temp.2014 <- KRK.temp.2014[1:N.dni.roku,]
KRK.temp.2015 <- KRK.data[year(KRK.data$date) == 2015, ]
KRK.temp.2015 <- KRK.temp.2015[1:N.dni.roku,]

KRK.temp.avg.2014 <- timeAverage( KRK.temp.2014,  avg.time = "year")
KRK.temp.avg.2015 <- timeAverage( KRK.temp.2015 , avg.time = "year" )

#############################3 zadanie 4 #######################################

KRK.srednie.dobowe <- timeAverage( KRK.data, avg.time = "day" )

NROW( KRK.srednie.dobowe$Aleje[KRK.srednie.dobowe$Aleje>50 &
                                 year(KRK.srednie.dobowe$date) == 2014 ] )
NROW( KRK.srednie.dobowe$Aleje[KRK.srednie.dobowe$Aleje>50 &
                                 year(KRK.srednie.dobowe$date) == 2015 ] )
NROW( KRK.srednie.dobowe$Aleje[KRK.srednie.dobowe$Aleje>50 &
                                 year(KRK.srednie.dobowe$date) == 2016 ] )

NROW( KRK.srednie.dobowe$Bujaka[KRK.srednie.dobowe$Bujaka>50 &
                                  year(KRK.srednie.dobowe$date) == 2014 ] )
NROW( KRK.srednie.dobowe$Bujaka[KRK.srednie.dobowe$Bujaka>50 &
                                  year(KRK.srednie.dobowe$date) == 2015 ] )
NROW( KRK.srednie.dobowe$Bujaka[KRK.srednie.dobowe$Bujaka>50 &
                                  year(KRK.srednie.dobowe$date) == 2016 ] )

NROW( KRK.srednie.dobowe$Bulwarowa[KRK.srednie.dobowe$Bulwarowa>50 &
                                     year(KRK.srednie.dobowe$date) == 2014 ] )
NROW( KRK.srednie.dobowe$Bulwarowa[KRK.srednie.dobowe$Bulwarowa>50 &
                                     year(KRK.srednie.dobowe$date) == 2015 ] )
NROW( KRK.srednie.dobowe$Bulwarowa[KRK.srednie.dobowe$Bulwarowa>50 &
                                     year(KRK.srednie.dobowe$date) == 2016 ] )

KRK.srednie.dobowe[KRK.srednie.dobowe$Aleje>50 &
                     year(KRK.srednie.dobowe$date) == 2014 ,][36,1]$date- ISOdate(2014,01,01,00, tz = "CET")
KRK.srednie.dobowe[KRK.srednie.dobowe$Aleje>50 &
                     year(KRK.srednie.dobowe$date) == 2015 ,][36,1]$date- ISOdate(2015,01,01,00, tz = "CET")
KRK.srednie.dobowe[KRK.srednie.dobowe$Aleje>50 &
                     year(KRK.srednie.dobowe$date) == 2016 ,][36,1]$date- ISOdate(2016,01,01,00, tz = "CET")


KRK.srednie.dobowe[KRK.srednie.dobowe$Bujaka>50 &
                     year(KRK.srednie.dobowe$date) == 2014 ,][36,1]$date- ISOdate(2014,01,01,00, tz = "CET")
KRK.srednie.dobowe[KRK.srednie.dobowe$Bujaka>50 &
                     year(KRK.srednie.dobowe$date) == 2015 ,][36,1]$date- ISOdate(2015,01,01,00, tz = "CET")
KRK.srednie.dobowe[KRK.srednie.dobowe$Bujaka>50 &
                     year(KRK.srednie.dobowe$date) == 2016 ,][36,1]$date- ISOdate(2016,01,01,00, tz = "CET")

KRK.srednie.dobowe[KRK.srednie.dobowe$Bulwarowa>50 &
year(KRK.srednie.dobowe$date) == 2014 ,][36,1]$date - ISOdate(2014,01,01,00, tz = "CET")

KRK.srednie.dobowe[KRK.srednie.dobowe$Bulwarowa>50 &
                     year(KRK.srednie.dobowe$date) == 2015 ,][36,1]$date - ISOdate(2015,01,01,00, tz = "CET")
KRK.srednie.dobowe[KRK.srednie.dobowe$Bulwarowa>50 &
                     year(KRK.srednie.dobowe$date) == 2016 ,][36,1]$date- ISOdate(2016,01,01,00, tz = "CET")

############################################ zadanie 5 ############################################

KRK.data <- cutData( KRK.data, type = "season")
przebieg.dobowy.zima <- data.frame( godzina = 0:23, 
                                      Aleje = NA,
                                      Bujaka = NA,
                                      Bulwarowa = NA,
                                      Season = "zima")
przebieg.dobowy.wiosna <- data.frame( godzina = 0:23, 
                                    Aleje = NA,
                                    Bujaka = NA,
                                    Bulwarowa = NA,
                                    Season = "wiosna")
przebieg.dobowy.lato <- data.frame( godzina = 0:23, 
                                    Aleje = NA,
                                    Bujaka = NA,
                                    Bulwarowa = NA,
                                    Season = "lato")
przebieg.dobowy.jesien <- data.frame( godzina = 0:23, 
                                    Aleje = NA,
                                    Bujaka = NA,
                                    Bulwarowa = NA,
                                    Season = "jesien")
#sredni przebieg dobowy zima:
for( i in 0:23 ){
pojedyncza.godzina <- subset( KRK.data , hour(KRK.data$date) == i & KRK.data$season == "winter (DJF)" )
przebieg.dobowy.zima[i+1, 2:4 ] <- colMeans( pojedyncza.godzina[,2:4] , na.rm = T)
}
#sredni przebieg dobowy wiosna:
for( i in 0:23 ){
  pojedyncza.godzina <- subset( KRK.data , hour(KRK.data$date) == i & KRK.data$season == "spring (MAM)" )
  przebieg.dobowy.wiosna[i+1, 2:4 ] <- colMeans( pojedyncza.godzina[,2:4] , na.rm = T)
}
#sredni przebieg dobowy lato:
for( i in 0:23 ){
  pojedyncza.godzina <- subset( KRK.data , hour(KRK.data$date) == i & KRK.data$season == "summer (JJA)" )
  przebieg.dobowy.lato[i+1, 2:4 ] <- colMeans( pojedyncza.godzina[,2:4] , na.rm = T)
}
#sredni przebieg dobowy jesien:
for( i in 0:23 ){
  pojedyncza.godzina <- subset( KRK.data , hour(KRK.data$date) == i & KRK.data$season == "autumn (SON)" )
  przebieg.dobowy.jesien[i+1, 2:4 ] <- colMeans( pojedyncza.godzina[,2:4] , na.rm = T)
}

przebieg.dobowy <- rbind( przebieg.dobowy.lato , przebieg.dobowy.jesien, przebieg.dobowy.zima, przebieg.dobowy.wiosna)    

plot.5 <- xyplot( Aleje+Bujaka+Bulwarowa ~ godzina | Season , data = przebieg.dobowy, 
                  type = "l", lwd = 2, col = c("red", "green", "blue") , fontsize=30, 
                  key=list(corner = c(0.9,0.9) ,lines=list(col=c("red", "green", "blue")),
                           text=list(c("Aleje","Bujaka","Bulwarowa"), fontsize=40),fontsize=40),
                  xlab = "", ylab = "PM.10 [ug/m3]",
                  scales = list( par.settings = simpleTheme( col = c("red", "green", "blue")))
)

png(filename="C:/Amadeusz_all_files/Pakiet_R/sprawozdanie_2/WIOS/graph.jpg" , width = 800, height = 800 )
print( plot.5, more = FALSE )
dev.off()

####################################### zadanie 6 ###################################3


library( lattice )
xyplot( Aleje ~ date,
        data = KRK.data )

plot.61 <- xyplot( Aleje ~ Bulwarowa,
        data = KRK.data, xlab = "Bulwarowa PM10 [ug/m3]", ylab = "Aleje PM.10 [ug/m3]",
        pch = 20, cex = .2,
        panel = function(x,y,...){
          panel.xyplot(x,y,...)
          panel.lmline(x,y, col = "black")
        })
plot.62 <- xyplot( Aleje ~ Bujaka,
                   data = KRK.data, col = "green",
                   pch = 20, cex = .2, 
                   xlab = "Bujaka PM10 [ug/m3]", ylab = "Aleje PM.10 [ug/m3]",
                   panel = function(x,y,...){
                     panel.xyplot(x,y,...)
                     panel.lmline(x,y,col = "black")
                   })

plot.63 <- xyplot( Bujaka ~ Bulwarowa,
                   data = KRK.data, col = "red",
                   pch = 20, cex = .2,
                   xlab = "Bulwarowa PM10 [ug/m3]", ylab = "Bujaka PM.10 [ug/m3]",
                   panel = function(x,y,...){
                     panel.xyplot(x,y,...)
                     panel.lmline(x,y,col = "black")
                   })

cor(KRK.data$Aleje, KRK.data$Bujaka)
cor(KRK.data$Aleje, KRK.data$Bulwarowa)
cor(KRK.data$Bulwarowa,KRK.data$Bujaka)

png(filename="C:/Amadeusz_all_files/Pakiet_R/sprawozdanie_2/WIOS/plott.jpg" , width = 800, height = 800 )      
print( plot.61 , split=c(1,1,2,2), more = TRUE )
print( plot.62 , split=c(1,2,2,2), more = TRUE )
print( plot.63 , split=c(2,1,2,2), more = FALSE )
dev.off()




































