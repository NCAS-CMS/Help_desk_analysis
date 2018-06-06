#
# R commands
# W. McGinty,8th Sep 2017
#
# Plot a stacked bar chart of the hel desk statistics
#
#
X11.options(type="Xlib") # fast plotting

# input is Year, Tickets, Reporters
stats_in<-read.table("tickets_summary2.csv",sep=",",header=FALSE)

barplot(t(stats_in),main="Help desk History",col=c("darkblue","red"),
        names=colnames(t(stats_in)),legend=colnames(t(stats_in)))
