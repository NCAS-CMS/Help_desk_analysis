#
# R commands
# W. McGinty, 14 Feb 2019
#
# Plot history of CMS responses by month
#
#
X11.options(type="Xlib") # fast plotting

# input is Year, Month, Tickets
stats_in<-read.table("months.csv",sep=",",header=TRUE)

stats_in$Year <- as.numeric(as.character(stats_in$Year), "%Y")

stats_in$Month<-factor(as.character(stats_in$Month))

stats_in$Tickets <-as.numeric(as.character(stats_in$Tickets))

# Remove tail end which has zero tickets - there are no months with zero tickets
stats=stats_in[stats_in$Tickets>0,]

N=length(stats$Year)

days=rep(14,N)

fred=as.character(paste(stats$Year, stats$Month, days,sep="-"))

StatsDates=as.Date(as.character(fred),"%Y-%m-%d")
pig=as.factor(format(StatsDates,"%b"))

title=paste(sprintf("CMS Help Tickets per month - colour by month\n"))
#jpeg(filename="months_tkts.jpeg")

plot(StatsDates,stats$Tickets,pch=16,col=stats_in$Month,xlab="Year",ylab="Tickets",main=title)

plot(stats$Tickets ~ stats$Month,xlab="Month", main="Tickets per month")

#Hooray!
plot(stats$Tickets ~ pig,xlab="Month", main="Tickets per month")


     