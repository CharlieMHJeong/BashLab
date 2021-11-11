#!/bin/bash

#merge final files then display as below
merge_finals(){
paste names_final.txt phones_final.txt  email_final.txt > final.txt
while read FN LN P E
do
  CNT=$((CNT+1))
  echo "NAME: ${FN} ${LN}"
  echo "PHONE: ${P}"
  echo "Email: ${E}"
  echo "============================" 
done < final.txt
}

merge_finals
echo "Total: ${CNT}"
