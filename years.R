#
# R commands
# W. McGinty, 8th December, 2017
#
# Plot history of CMS responses
#
#
X11.options(type="Xlib") # fast plotting

# input is Year, Tickets, Reporters
stats_in<-read.table("years.csv",sep=",",header=TRUE)

N=length(stats_in$Year)

title=paste(sprintf(" CMS Help Tickets\n"))
jpeg(filename="years_tkts.jpeg")
barplot(stats_in$Tickets,names.arg=stats_in$Year, xlab="Year",ylab="Tickets",main=title)

title=paste(sprintf("CMS Help Reporters\n",N))
jpeg(filename="years_reps.jpeg")
barplot(stats_in$Reporters,names.arg=stats_in$Year, xlab="Year",ylab="Reporters",main=title)


#Put both plots on one graph
# First transpose the data
fredt=t(stats_in[,2:ncol(stats_in)])
colnames(fredt)=stats_in[,1]

jpeg(filename="years_vols.jpeg")
barplot(fredt,main="CMS Help desk volumes",ylab="Number",beside=TRUE,col=terrain.colors(2))
legend("topleft",c("Tickets","Reporters"), cex=0.8,fill=terrain.colors(2))

