#!/bin/bash
#
# W. McGinty
# 28th Nov 2017
#
# Find number of number of tickets and reporters for each year
#
# Use 'here' document for SQL so we can modify the year range
#
if [[ $# != 1 ]]  ;then
  echo "Usage: year_summary.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

yearmax=$1

tempfile=$(mktemp --tmpdir)

# Header line
echo Year,Tickets,Reporters > years.csv

for ((year=2007; year<=yearmax;year++))
do
  yearp1=$((year+1))

  sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select count(*)
from ticket
where time >= strftime('%s','$year-01-01')*1e6 and
      time < strftime('%s','$yearp1-01-01')*1e6;
.exit
EOF

  Num_tickets=$(cat $tempfile)

  sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select reporter, count(*)
from ticket
where time >= strftime('%s','$year-01-01')*1e6 and
      time < strftime('%s','$yearp1-01-01')*1e6
group by reporter;
.exit
EOF

  Num_reporters=$(cat $tempfile | wc -l)

  echo $year, $Num_tickets, $Num_reporters >> years.csv

done

Rscript years.R

#rm years.csv

rm $tempfile
