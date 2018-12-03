#!/bin/bash
#
# W. McGinty
# 30th Nov 2017
#
# Find for each ticket the time to first response
#
#
if [[ $# != 1 ]]  ;then
  echo "Usage: response_time.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

tempfile=$(mktemp --tmpdir)

year=$1
yearp1=$((year+1))

echo ticket,response_time_hrs > helpdesk_1st_response_time.csv

#
# oldvalue is overloaded. It is usually the comment number, butcan contain things like 'description.1'
# and, if inline comments are used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer - note that this will give an
# error if presented with a non-integer.
#
sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket.id, ((ticket_change.time - ticket.time)/1e6)/3600.0
from ticket, ticket_change
where ticket.id = ticket_change.ticket and
     type is not 'task' and
     ticket_change.oldvalue='1' and
     ticket.time >= strftime('%s','$year-01-01')*1e6 and
     ticket.time < strftime('%s','$yearp1-01-01')*1e6
order by ticket.id asc;
.exit
EOF

cat $tempfile >> helpdesk_1st_response_time.csv

# Use R to get the plots - creates Rplots.pdf
Rscript proc_response_time.R $year

#rm helpdesk_1st_response_time.csv

rm $tempfile
