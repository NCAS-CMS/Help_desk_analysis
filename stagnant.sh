#!/bin/bash
#
# W. McGinty
# 30th Nov 2017
#
# List active tickets that are stagnant i.e. have had no response for two months.
#
#
tempfile=$(mktemp --tmpdir)

echo "Ticket, LastChanged, Owner" > active_stagnant.csv

#
# oldvalue is overloaded. It is usually the comment number, butcan contain things like 'description.1'
# and, if inline comments are used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer - note that this will give an
# error if presented with a non-integer.
#
now=$(date +%F)
old=$(date -d "$now - 2 months" "+%F")

sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket, date(ticket_change.time/1e6,"unixepoch"),ticket.owner
from ticket, ticket_change
 where ticket.id=ticket_change.ticket and ticket.status not like 'closed'
  and type is not 'task'
  and ticket_change.time <=strftime('%s','$old')*1e6
group by ticket_change.ticket
order by ticket_change.time;
.exit
EOF

cat $tempfile >> active_stagnant.csv
# Use R to get the plots - creates Rplots.pdf
#Rscript proc_max_comments.R

rm $tempfile
