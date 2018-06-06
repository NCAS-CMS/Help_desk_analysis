#
# R commands
# W. McGinty,11th Sep 2017
#
# Plot histograms of the responses per ticket.
#
#
X11.options(type="Xlib") # fast plotting

# input is Ticket, Comments
stats_in<-read.table("max_comments_per_ticket2.csv",sep=",",header=TRUE)

N=length(stats_in$Tickets)

title=paste(sprintf("Histogram of responses per ticket, %d tickets\n",N))
jpeg(filename="responses_per_ticket.jpeg")
fred=hist(stats_in$Comments, main=title,xlab="responses")

#Plot log frequencies
fred$counts[fred$counts<=0]=1 # prevent taking log of zero
fred$counts=log10(fred$counts)
jpeg(filename="responses_per_ticket_log.jpeg")
plot(fred,main=title,xlab="responses", ylab="log10(Frequency)")
