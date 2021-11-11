#!/bin/bash
#
#3GET 3 ARGs
#names.txt -> snames.txt
#phones.txt -> sphones.txt
#emails.txt -> semails.txt
#
#With 3 files above
#
#final.txt
#
#ID:
#name: aaa
#phone: +61341
#emails: email@email.com
#==============================
#total:

NAME="${1}"
PHONE="${2}"
EMAIL="${3}"

if [[ ${NAME} != 'names.txt' ]] || [ ${PHONE} != 'phones.txt' ] || [ ${EMAIL} != 'emails.txt' ]
then
  echo "Please provide 3 ARGs as below:" >&2
  echo "USAGE: ${0} names.txt phones.txt emails.txt" >&2
  exit 1
fi

process_fnames() {
  #cat names.txt | awk  '{print $1, $2}' > awk_names.txt
  for LINE in names.txt
  do
    FNAME=$(cat ${LINE} | awk '{print $1}'| tr 'A-Z' 'a-z' | sed 's/.*/\u&/'  )
    echo "${FNAME}" >> names_first.txt
  done
}

process_lnames() {
  for LINE in names.txt
  do
    #LNAME=$(cat ${LINE} | awk '{print $2}'| tr 'A-Z' 'a-z' | sed 's/.*/\u&/' | tr '[!a-zA-Z]' '' )
    LNAME=$(cat ${LINE} | awk '{print $2}' | tr 'A-Z' 'a-z' | tr -cs [a-z] "\n" | sed 's/.*/\u&/' )
    echo "${LNAME}" >> names_last.txt
  done
}

generate_names_final() {
  paste -d " " names_first.txt names_last.txt > names_final.txt
}

process_phones() {
  for LINE in phones.txt
  do
    LNAME=$(cat ${LINE} | awk '{print $2}' | tr 'A-Z' 'a-z' | tr -cs [a-z] "\n" | sed 's/.*/\u&/' )
    echo "${LNAME}" >> names_last.txt
  done
}

process_format_phones() {
  for LINE in "${PHONE}"
  do
    #GOOD
    #LINE=$(cat "${LINE}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610/61/' | sed 's/^+*//' )
    #LINE=$(cat "${LINE}" | tr -d " \t\r"| sed 's/^0*/+61/' | sed 's/+610*/+61/'| sed 's/[^0-9|+]*//g')
    #LINE=$(cat "${LINE}" | tr -d " \t\r"| sed 's/^0*/+61/' | sed 's/+610*/+61/')

    LINE=$(cat "${LINE}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610*/61/' | sed 's/^+*//' | sed 's/^61*//')
    echo "${LINE}" >> phones_formatted.txt 
  done
}

process_final_phones() {
  for P_LINE in $(cat phones_formatted.txt)
  do
    LINE_LEN=$( echo ${P_LINE} | wc -c  )
    if [[ "${LINE_LEN}" -ne 10 ]]
    then 
      PHONE_LINE=${P_LINE}-InvalidNumber
      echo "${PHONE_LINE}" >> phones_final.txt
    else
      PHONE_LINE="+61${P_LINE}"
      echo "${PHONE_LINE}" >> phones_final.txt
    fi
  done
}

process_emails() {
  for LINE in "${EMAIL}"
  do
    #LINE=$(cat "${LINE}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610*/61/' | sed 's/^+*//' | sed 's/^61*//')
    LINE=$(cat "${LINE}" | tr 'A-Z' 'a-z' | awk -F '@' '{print $1"@"$NF}' | sed -e 's/\.\.*/\./' | sed 's/au.au/au/' )
    echo "${LINE}" >> email_final.txt 
  done
}


process_lnames
process_fnames
generate_names_final

process_format_phones
process_final_phones

process_emails
