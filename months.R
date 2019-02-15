#
# R commands
# W. McGinty, 14 Feb 2019
#
# Plot history of CMS responses by month
#
#
X11.options(type="Xlib") # fast plotting

# input is Date, Tickets where the Date is nominally the centre of the month
#  This is so we can treat the whole thing as an ISO date.
stats_in<-read.table("months.csv",sep=",",header=TRUE)

statsDate <- as.Date(stats_in$Date, "%Y-%m-%d")

statsTickets <-as.numeric(as.character(stats_in$Tickets))

N=length(stats_in$Date)

StatMonths=ordered(format(as.Date(stats_in$Date),"%b"),
                   levels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
  
title=paste(sprintf("CMS Help Tickets per month - colour by month\n"))

#jpeg(filename="months_tkts.jpeg")

plot(statsDate, statsTickets,pch=16,col=StatMonths,xlab="Year",ylab="Tickets",main=title)

plot(statsTickets ~ StatMonths,xlab="Month", main="Tickets per month")


     