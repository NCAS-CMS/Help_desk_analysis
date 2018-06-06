#!/bin/bash
#
# W. McGinty
# 5th Dec 2017
#
# The aim is to collect the number of tickets, number of responses per
# instituion.  Normalised by the number of users at an institution.
#
# institutes.csv is the final answer
# institutes2.csv is for R processing, which currently does not do the
# aggregation and reduction of users.
#
if [[ $# != 1 ]]  ;then
  echo "Usage: analyze_inst.sh <year>" 1>&2
  echo " where year is after 2006" 1>&2
  exit 1
fi

tempfile=$(mktemp --tmpdir)

year=$1
yearp1=$((year+1))

output=institutes.csv
output2=institutes2.csv

# Step 1 create a list of ticket, responses, email of reporter in the
# time period
#
echo Institute,Tickets,Responses, Responses_per_tkt > $output

#
# oldvalue is overloaded. It is usually the comment number, but can
# contain things like 'description.1' and, if inline comments are
# used, '8.9' i.e. mid way between two comments.
#
# In order for max to work we must convert the old values to integer -
# note that this will give an error if presented with a non-integer.
#
sqlite3 -csv ~/Helpdesk/trac_latest.db > $tempfile <<EOF
select ticket.id, max(cast(oldvalue as integer)), ticket.reporter, session_attribute.value
from ticket_change, ticket,session_attribute
where   ticket_change.ticket=ticket.id and
	sid = ticket.reporter and session_attribute.value like '%@%' and
	ticket.time >= strftime('%s','$year-01-01')*1e6 and
	ticket.time < strftime('%s','$yearp1-01-01')*1e6
group by ticket.id;
.exit
EOF

# For debugging
#cat $tempfile > fred.csv

# Note the double back slash so we can use '.' as a field separator
# the lines are ----,----,----,---@---- where the - indicates
# characters. Separating by commas, we have ticket, number of
# responses, reporter, and email of reporter.
#
#Separating by '.' and '@', the third last field is the institution
#
#
echo Ticket,Responses,Reporter,Institute > $output2

cat $tempfile | \
    sed 's/.rdg./.reading./' | \
    #get the ticket, response and institution
    awk -F,  '{n=split($4,a,"@|\\.");
	  printf "%d,%d,%s,%s\n", $1, $2, $3, a[n-2]
    }' | \
    tee -a $output2 | \
    # Now use awk associative arrays to tot up the tickets and
    # responses for each institution
    grep -v Institute | \
    awk -F, '{total_tickets[$4]++
	 total_resps[$4] += $2}
	END { for (inst in total_tickets)
	      printf "%s,%d,%d,%f\n",
		 inst, total_tickets[inst], total_resps[inst],
		 total_resps[inst]/total_tickets[inst] }' | \
    sort -k2 -rn >> $output


# Get a list of the users per institute
for inst in $(cat institutes2.csv | grep -v Institute | awk -F, '{ print $4 }' | sort -u)
do
  num_users=$(grep "$inst\$" institutes2.csv | awk -F, '{ print $3 }' | sort -u | wc -l)
  echo $inst, $num_users
done > users.csv

# Now insert the users into each institute line in $output

echo Institute,Tickets,Responses, Users, Responses_per_tkt > institutes3.csv
IFS=,
cat $output | grep -v Institute | \
    while read inst tickets responses resppertkt
    do
	users=$(grep "^$inst," users.csv | awk -F, '{print $2}')
	echo $inst, $tickets, $responses, $users, $resppertkt
    done >> institutes3.csv

# Tidy up
rm $output
mv institutes3.csv $output

# Use R to get the plots labelled by $year
Rscript institutes.R $year

#rm $output

rm $tempfile
