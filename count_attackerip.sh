#!/bin/bash

# Count the number of failed logins by IP address.
# If there are any IPs with over LIMIT failures, display the count, IP, and location.

LIMIT='10'
GIVEN_FILE=${1}

if [[ ! -e ${GIVEN_FILE} ]]
then
  echo "Please provide a log file to process" >&2
  echo "Usage: ${0} <logfile to process>" >&2
  exit 1
fi

echo "COUNT, IP, Location"

grep ' Failed' ${GIVEN_FILE} | awk '{print $(NF-3)}' |  sort | uniq -c | sort -nr | while read COUNT IP
do
  LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $(NF)}')
  if [[ ${COUNT} -gt ${LIMIT} ]]
  then
    echo "${COUNT}, ${IP}, ${LOCATION}"
  fi
done
exit 0


