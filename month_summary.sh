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
if [[ $# != 1 ]]  ;then
  echo "Usage: month_summary.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

tempfile=$(mktemp --tmpdir)

year=$1

# Header line
echo Date, Tickets > months.csv

for ((yr=2007; yr<=$year; yr++))
do
  yearp1=$((yr+1))

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
      time >= strftime('%s','$yr-$mnth-01')*1e6 and
      time < strftime('%s','$yr-$mnth1-01')*1e6;
.exit
EOF
      else
  sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select count(*)
from ticket
where type is not 'task' and
      time >= strftime('%s','$yr-$mnth-01')*1e6 and
      time < strftime('%s','$yearp1-01-01')*1e6;
.exit
EOF
      fi

   Num_tickets=$(cat $tempfile)
   #
   # Only output to current month - future months will have zero tickets
   #
   if [[ $Num_tickets > 0 ]] ; then
       echo $yr-$mnth-14, $Num_tickets >> months.csv
   fi
  done
done

rm $tempfile

Rscript months.R
