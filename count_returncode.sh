#!/bin/bash
#nginx.log
#64-249-27-114.client.dsl.net - - [11/Mar/2004:14:53:12 -0800] "GET /SpamAssassin.html HTTP/1.1" 200 7368
#pd9eb1396.dip.t-dialin.net - - [11/Mar/2004:15:17:08 -0800] "GET /AmavisNew.html HTTP/1.1" 200 2300
#10.0.0.153 - - [11/Mar/2004:15:51:49 -0800] "GET / HTTP/1.1" 304 -
#10.0.0.153 - - [11/Mar/2004:15:52:07 -0800] "GET /twiki/bin/view/Main/WebHome HTTP/1.1" 200 10419
#10.0.0.153 - - [11/Mar/2004:15:52:07 -0800] "GET /twiki/pub/TWiki/TWikiLogos/twikiRobot46x50.gif HTTP/1.1" 304 -
#10.0.0.153 - - [11/Mar/2004:15:52:12 -0800] "GET /twiki/bin/view/Main/WebHome HTTP/1.1" 200 10419
#pd9eb1396.dip.t-dialin.net - - [11/Mar/2004:15:17:08 -0800] "GET /AmavisNew.html HTTP/1.1" 500 2300
#64-249-27-114.client.dsl.net - - [11/Mar/2004:14:53:12 -0800] "GET /SpamAssassin.html HTTP/1.1" 304 7368
#10.0.0.153 - - [11/Mar/2004:15:52:12 -0800] "GET /twiki/bin/view/Main/WebHome HTTP/1.1" 500 10419
#pd9eb1396.dip.t-dialin.net - - [11/Mar/2004:15:17:08 -0800] "GET /AmavisNew.html HTTP/1.1" 201 2300
#read log from nginx.log 
#Produce a list of the top hosts that returned return code NNN, and the count of that code.
#
#Example output for code 200:
#
#host,count
#10.0.0.153,2
#pd9eb1396.dip.t-dialin.net,1
#64-249-27-114.client.dsl.net,1

GIVEN_FILE=${1}
if [[ ! -e ${GIVEN_FILE} ]]
then
  echo "Pleae proved log file to process" >&2
  echo "Usage: ${0} <Logfile to process> " >&2
  exit 1
fi

getcode(){
  awk '{print $(NF-1)}' ${GIVEN_FILE} | sort | uniq
}

CODES=$(getcode)

for CODE in ${CODES}
do
  echo ""
  echo "Counting the code: ${CODE}"
  echo "HOST, COUNT"  
  grep " ${CODE} " ${GIVEN_FILE} | awk '{print $1}' | sort | uniq -c | while read COUNT HOST
  do
    echo "${HOST}, ${COUNT}"  
  done
  echo ""
done
