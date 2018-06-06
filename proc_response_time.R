#
# R commands
# W. McGinty,14th Sep 2017
#
# Plot histograms of the first response time
#
#
args <- commandArgs(trailingOnly = TRUE)
year=as.numeric(args[1])

X11.options(type="Xlib") # fast plotting

# input is ticket, response_time_hrs
stats_in<-read.table("helpdesk_1st_response_time.csv",sep=",",header=TRUE)

N=length(stats_in$ticket)

maxtime=0.5*365.25 # 0.5 yrs in days
maxtime=1000/24.0
title=paste(sprintf("Histogram of ticket reponse time %d, %d tickets\n",year, N))
stats_in$response_time_hrs[stats_in$response_time_hrs/24.0>maxtime]=maxtime
jpeg(filename="response_time_hist.jpeg")
fred=hist(stats_in$response_time_hrs/24.0, main=title,xlab="Days")

M=length(stats_in$response_time_hrs)

h=ecdf(stats_in$response_time_hrs/24.0)
jpeg(filename="response_time.jpeg")
title=paste(sprintf("Cumulative distribution of ticket reponse time %d, %d tickets\n",year, N))
plot(h,xlab="response time days",ylab="Frac < response",main=title)

#lot log frequencies
fred$counts[fred$counts<=0]=1 # prevent taking log of zero
fred$counts=log10(fred$counts)
jpeg(filename="response_time_log.jpeg")
plot(fred,main=title,xlab="response time days", ylab="log10(Frequency)")

#end