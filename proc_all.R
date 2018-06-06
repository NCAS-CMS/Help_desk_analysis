#
# R commands
# W. McGinty,8th Sep 2017
#
# Plot a stacked bar chart of the hel desk statistics
#
#
X11.options(type="Xlib") # fast plotting

# input is Year, Tickets, Reporters
stats_in<-read.table("tickets_summary.csv",sep=",",header=TRUE)

old.par <- par(mfrow=c(2, 1))
barplot(stats_in$Tickets,main="Help desk History: tickets",names.arg=stats_in$Year)
barplot(stats_in$Reporters,main="Help desk History: reporters",names.arg=stats_in$Year)
par(old.par)