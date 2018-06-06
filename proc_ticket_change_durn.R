#
# R commands
# W. McGinty,15th Sep 2017
#
# Look at the durations of the tickets
#
#
X11.options(type="Xlib") # fast plotting

rm(list = ls()) # remove previous objects

# input is ticket, duration_days
stats_in<-read.table("ticket_change_duration_days.csv",sep=",",header=TRUE)

N=length(stats_in$ticket)

max_duration=500 # days
stats_in$duration_days[stats_in$duration_days>max_duration]=max_duration

title=paste(sprintf("Proportion of tickets closed within duration, %d tickets\n",N))
h=ecdf(stats_in$duration_days)
jpeg(filename="tickets_closed.jpeg")
plot(h,main=title, xlab="Duration, days")

title=paste(sprintf("Histogram of ticket duration, %d tickets\n",N))
jpeg(filename="ticket_durn_hist.jpeg")
fred=hist(stats_in$duration_days, main=title,xlab="Duration, days")

#Plot log frequencies
fred$counts[fred$counts<=0]=1 # prevent taking log of zero
counts=fred$counts

fred$counts=log10(fred$counts)
jpeg(filename="tickets_closed_log.jpeg")
plot(fred,main=title,xlab="Duration, days", ylab="log10(Frequency)",col=("yellow"))

#end