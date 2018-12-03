#!/bin/bash
#
# W. McGinty
# 20 Mar 2018
#
# Find number of number of tickets for each month.
#
#  This is the number of active tickets per month.  Do we want
# the number of new tickets in the month?
#
# Use 'here' document for SQL so we can modify the year range
#
tempfile=$(mktemp --tmpdir)

# Header line
echo Year, Month, Tickets > months.csv

for ((year=2007; year<2019; year++))
do
  yearp1=$((year+1))

  # months in 2 digit padded form
  for month in $(seq  1 12)
  do
      mnth=$(printf "%02d\n" $month)

      temp=$((month+1))
      mnth1=$(printf "%02d\n" $temp)

      if ((temp != 13)); then
  sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select count(*)
from ticket
where type is not 'task' and
      time >= strftime('%s','$year-$mnth-01')*1e6 and
      time < strftime('%s','$year-$mnth1-01')*1e6;
.exit
EOF
      else
  sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select count(*)
from ticket
where type is not 'task' and
      time >= strftime('%s','$year-$mnth-01')*1e6 and
      time < strftime('%s','$yearp1-01-01')*1e6;
.exit
EOF
      fi

   Num_tickets=$(cat $tempfile)

  echo $year, $mnth, $Num_tickets >> months.csv
  done
done

#Rscript years.R

#rm years.csv

rm $tempfile
