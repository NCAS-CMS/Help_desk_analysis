#
# R commands
# W. McGinty, 7th December, 2017
#
# Plot histograms of activity per institute
#
#
args <- commandArgs(trailingOnly = TRUE)
year= as.numeric(args[1])

X11.options(type="Xlib") # fast plotting

# input is Institute,Tickets,Responses,Users Responses_per_tkt,
stats_in<-read.table("institutes.csv",sep=",",header=TRUE)

N=length(stats_in$Institute)

tkts_per_user = stats_in$Tickets/stats_in$Users

title=paste(sprintf("Tickets/Reporter by institute %d, %d institutes\n",year, N))
jpeg(filename="institutes_tktsbyrep.jpeg",width=1280,height=512)
barplot(tkts_per_user,names.arg=stats_in$Institute, xlab="Institute",ylab="Ticket/Reporter",col="light blue",main=title)


title=paste(sprintf("Reporters by institute %d, %d institutes\n",year,N))
jpeg(filename="institutes_byrep.jpeg",width=1280,height=512)
barplot(stats_in$Users,names.arg=stats_in$Institute, xlab="Institute",ylab="Reporters",col="yellow",main=title)


title=paste(sprintf("Responses/Ticket by institute %d, %d institutes\n",year, N))
jpeg(filename="institutes_respbytkt.jpeg",width=1280,height=512)
barplot(stats_in$Responses_per_tkt,names.arg=stats_in$Institute, xlab="Institute",ylab="Responses/ticket",col="green",main=title)

