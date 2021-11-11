./process_userdetails_1.1.sh names.txt phones.txt emails.txt
sleep 1
./merge_finalfiles_1.1.sh
sleep 1
echo ""
echo ""
echo "Deleting finalfiles"
./delete_previous_lab_files.sh 
