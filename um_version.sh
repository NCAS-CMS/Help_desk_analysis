#!/bin/bash
#
# W. McGinty
# 30th Nov 2017
#
# Find for each ticket the duration in days
#
#
if [[ $# != 1 ]]  ;then
  echo "Usage: um_version.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

tempfile=$(mktemp --tmpdir)

year=$1
yearp1=$((year+1))

output=um_versions.csv

echo ticket,version > $output

#
# oldvalue is overloaded. It is usually the comment number, butcan contain things like 'description.1'
# and, if inline comments are used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer - note that this will give an
# error if presented with a non-integer.
#
sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket_custom.ticket, ticket_custom.value
from ticket_custom, ticket
where ticket_custom.ticket=ticket.id and
     type is not 'task' and
     value is not '' and
     value not like '<select%' and
     value not in ('ARCHER','PUMA','MONSooN','Monsoon2','NEXCS','Other') and
     ticket.time >= strftime('%s','$year-01-01')*1e6 and
     ticket.time < strftime('%s','$yearp1-01-01')*1e6
group by ticket
order by value;
.exit
EOF

cat $tempfile >> $output

# Use R to get the plots - creates Rplots.pdf
Rscript um_versions_hist.R

rm $output

rm $tempfile
