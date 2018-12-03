#!/bin/bash
#
# W. McGinty
# 30th Nov 2017
#
# Find for each ticket the number of comments
#
#
if [[ $# != 1 ]]  ;then
  echo "Usage: comments_per_ticket.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi
year=$1
yearp1=$((year+1))

tempfile=$(mktemp --tmpdir)

echo Tickets, Comments > max_comments_per_ticket2.csv

#
# oldvalue is overloaded. It is usually the comment number, butcan contain things like 'description.1'
# and, if inline comments are used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer - note that this will give an
# error if presented with a non-integer.
#
sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket_change.ticket,max(cast(oldvalue as integer))
from ticket_change, ticket
where ticket.id=ticket_change.ticket and
        type is not 'task' and
        field="comment" and oldvalue not like 'descri%' and oldvalue not like '%.%' and
        ticket_change.time >= strftime('%s','$year-01-01')*1e6 and
        ticket_change.time < strftime('%s','$yearp1-01-01')*1e6
group by ticket;
.exit
EOF

cat $tempfile >> max_comments_per_ticket2.csv

# Use R to get the plots - creates Rplots.pdf
Rscript proc_max_comments.R

#rm max_comments_per_ticket2.csv

rm $tempfile
