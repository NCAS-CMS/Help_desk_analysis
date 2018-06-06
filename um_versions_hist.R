#
# R commands
# W. McGinty,15 Nov 2017
#
# Plot histograms of the UM versions
#
#
X11.options(type="Xlib") # fast plotting

# input is ticket,version
stats_in<-read.table("um_versions.csv",sep=",",header=TRUE)

N=length(stats_in$ticket)

title=paste(sprintf("Histogram of UM versions, %d tickets\n",N))
#fred=hist(stats_in$version, main=title,xlab="version")

#plot(fred,main=title,xlab="version", ylab="Frequency")
jpeg(filename="um_versions_hist.jpeg",width=1096,height=555)
barplot(summary(stats_in$version),xlab="UM version",ylab="Frequency",main=title)
