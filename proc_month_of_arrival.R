#
# R commands
# W. McGinty, 15th Sep 2017
#
# Plot a stacked bar chart of the hel desk statistics
#
#
X11.options(type="Xlib") # fast plotting

# input is year, month, day, ticket
stats_in<-read.table("ticket_month_of_arrival2.csv",sep=",",header=TRUE)

N= length(stats_in$ticket)
title=paste(sprintf("Monthly distribution of %d tickets\n",N))
months=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
h=table(stats_in$month)
barplot(h,main=title,xlab="month",col=c("green"),names.arg=months)
