#!/bin/bash

check_su_privileges() {
  #make sure the script is being executed with su privileges.
  if [[ "${UID}" -ne 0 ]]
then 
  #Returns non-zero status on error.
    echo "Please run this command as superuser privileges" 1>&2
    exit 1 
  fi
}

log() {
  #This function sends a message to syslog and to standard output if VERBOSE is true
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
  logger -t backup.sh "${MESSAGE}"
}

backup_dir() {
#This function is going to backup the directory in the 1st argument. 
#Returns non-zero status on error.
  local DIR="${1}"
 
  #Make sure the Directory exists
  if [[ -d "${DIR}" ]]
  then
    #local BACKUP_FILE="web_$(date +%F-%T.%N)"
    local BACKUP_FILE="web_$(date +%d_%m_%y_%H_%M)"
    log "Backing up /var/www/gogreen directory to /backup/${BACKUP_FILE}"
    tar -czPf "/backup/${BACKUP_FILE}.tar.gz" "${DIR}" 
    #The exit status of the function will be the exit status of tar command
  else
    #The file does not exist, returning non-zero exit status.
    echo "${DIR} does not Exist!" 1>&2
    return 1
  fi
}

check_backup() {
  # Make a decision based on the exit status of the function.
  if [[ "${?}" -eq 0 ]]
  then
    log 'DIR Backup Succeeded!!'
  else
    log 'DIR Backup Failed!!' 
    return 1
  fi
}

readonly VERBOSE='false'
check_su_privileges
backup_dir '/var/www/gogreen/'
check_backup

