#!/bin/bash
#
# W. McGinty
# 30th Nov 2017
#
# Find for each ticket the duration in days
#
#
if [[ $# != 1 ]]  ;then
  echo "Usage: ticket_duration.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

tempfile=$(mktemp --tmpdir)

year=$1
yearp1=$((year+1))

output=ticket_change_duration_days.csv

echo ticket,duration_days > $output

#
# oldvalue is overloaded. It is usually the comment number, butcan contain things like 'description.1'
# and, if inline comments are used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer - note that this will give an
# error if presented with a non-integer.
#
sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket,(((max(time)-min(time))/1e6)/3600.0)/24.0
from ticket_change
where time >= strftime('%s','$year-01-01')*1e6 and
      time < strftime('%s','$yearp1-01-01')*1e6
group by ticket;
.exit
EOF

cat $tempfile >> $output

# Use R to get the plots - creates Rplots.pdf
Rscript proc_ticket_change_durn.R

rm $output

rm $tempfile
