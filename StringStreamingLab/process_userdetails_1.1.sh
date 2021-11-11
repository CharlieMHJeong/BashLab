#!/bin/bash
#This script will get 3 ARGs and process them as below
#names.txt -> snames.txt
#phones.txt -> sphones.txt
#emails.txt -> semails.txt
#
#
# OUTPUTS: 
#name: aaa
#phone: +61341
#emails: email@email.com
#==============================
#total:


#Get 3 Args and assign to name, phone, email
name="${1}"
phone="${2}"
email="${3}"

#Display usage and exit 1
usage() {
  echo
  echo "Please provide 3 ARGs as below:" >&2
  echo "USAGE: ${0} names.txt phones.txt emails.txt" >&2
  echo
  exit 1
}


# if 3 ARGs not match, show usage
if [[ ${name} != 'names.txt' ]] || [ ${phone} != 'phones.txt' ] || [ ${email} != 'emails.txt' ]
then
  usage
fi

#get first name from names.txt, make 1st char to uppercase
process_fnames() {
  for line in names.txt
  do
    fname=$(cat ${line} | awk '{print $1}'| tr 'A-Z' 'a-z' | sed 's/.*/\u&/'  )
    echo "${fname}" >> names_first.txt
  done
}

#get last name from names.txt, make 1st char to uppercase
process_lnames() {
  for line in names.txt
  do
    lname=$(cat ${line} | awk '{print $2}' | tr 'A-Z' 'a-z' | tr -cs [a-z] "\n" | sed 's/.*/\u&/' )
    echo "${lname}" >> names_last.txt
  done
}

#merget firstname and lastname and generate names_final.txt
generate_names_final() {
  paste -d " " names_first.txt names_last.txt > names_final.txt
}


# Make numbers to E.164 AUS number
process_format_phones() {
  for line in "${phone}"
  do
    #GOOD
    #line=$(cat "${line}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610/61/' | sed 's/^+*//' )
    #line=$(cat "${line}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610*/61/' | sed 's/^+*//' | sed 's/^61*//')
    line=$(cat "${line}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610*/61/' | sed 's/^[+|61]*//')
    echo "${line}" >> phones_formatted.txt 
  done
}

# Validate the Phone Number
process_final_phones() {
  for p_line in $(cat phones_formatted.txt)
  do
    line_LEN=$( echo ${#p_line} )
    if [[ "${line_LEN}" -ne 9 ]]
    then 
      phone_line=${p_line}-InvalidNumber
      echo "${phone_line}" >> phones_final.txt
    else
      phone_line="+61${p_line}"
      echo "${phone_line}" >> phones_final.txt
    fi
  done
}

# Process emails
process_emails() {
  for line in "${email}"
  do
    #line=$(cat "${line}" | tr -d " \t\r"| sed 's/^0*//' | sed 's/^610*/61/' | sed 's/^+*//' | sed 's/^61*//')
    line=$(cat "${line}" | tr 'A-Z' 'a-z' | awk -F '@' '{print $1"@"$NF}' | sed -e 's/\.\.*/\./' | sed 's/au.au/au/' )
    echo "${line}" >> email_final.txt 
  done
}

process_lnames
process_fnames
generate_names_final

process_format_phones
process_final_phones

process_emails
