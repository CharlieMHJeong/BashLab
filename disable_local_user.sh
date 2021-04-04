#!/bin/bash
#
# This script disables, deletes, and/or archives users on the local system.
#

#Make sure this scripte is being executed super user privileges
if [[ "${UID}" -ne 0 ]]
then 
  echo "Please run this script with super user privileges!!" 1>&2
  exit 1
fi

ARCHIVE_DIR='/archive'
#echo ${ACHIVE_DIR}
#exit

usage () {
 #Display usage and exit 
 echo
 echo "Usage: {0} [-dra] USER [USERN]..." >&2
 echo "This script is disabling the account by default!" >&2
 echo " -d  : Deletes accounts instead of disabling them" >&2
 echo " -r  : Removes Home Directory associated with the accounts(s)" >&2
 echo " -a  : Create an archive of the home directory associated with the account(s)" >&2
 echo
 exit 1
}

# Parse the options.
while getopts dra OPTION
do
  case ${OPTION} in 
    d) DELETE_USER='true';;
    r) REMOVE_OPTION='-r';;
    a) ARCHIVE='true';;
    ?) usage;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

## If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do
  echo "Processing ${USERNAME}"
  # Make sure the UID of the account is at least 1000.
  USERID="$(id -u ${USERNAME})"
  if [[ "${USERID}" -lt 1000 ]]
  then 
    echo "Refusing to remove the ${USERNAME} account with UID ${USERID}" >&2
    exit 1
  fi 

  #  # Create an archive if requested to do so.
  if [[ "${ARCHIVE}" = 'true' ]]
  then
  # Make sure the ARCHIVE_DIR directory exists.
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory"
      mkdir -p ${ARCHIVE_DIR}
      if [[ "${?}" -ne 0 ]]
      then 
        echo "The archive directory ${ARCHIVE_DIR} could not be created!!" >&2
        exit 1
      fi
    fi

  #     # Archive the user's home directory and move it into the ARCHIVE_DIR
  HOME_DIR="/home/${USERNAME}"
  ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then 
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &>/dev/null
      if [[ "${?}" -ne 0 ]]
       then 
         echo "Could not create ${ARCHIVE_FILE}" >&2
         exit 1
      fi
    else
      echo "${HOME_DIR} Does not exist or is not a directory" >&2
    fi
  fi

if [[ "${DELETE_USER}" = 'true' ]]
then
  #Delete user
  echo "${USERNAME} being deleted" >&2
  userdel ${REMOVE_OPTION} ${USERNAME}

    # Check to see if the chage command succeeded.
    # We don't want to tell the user that an account was disabled when it hasn't been.
  if [[ "${?}" -ne 0 ]]
  then
    echo "The account ${USERNAME} not deleted"
    exit 1
  fi
  echo "The account ${USERNAME} deleted!!"

else
  chage -E 0 ${USERNAME}
  if [[ "${?}" -ne 0 ]]
  then
    echo "The account ${USERNAME} not disabled"
    exit 1
  fi
  echo "The account ${USERNAME} disabled!!"
fi  
done
exit 0
