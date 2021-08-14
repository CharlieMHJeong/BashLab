#!/bin/bash 
#
# This script disables, deletes, and/or archives users on this system
#

ARCHIVE_DIR='/archive'

usage() {
  # Display the usage and exit.
  echo "Usage: ${0} [-dra] USER [USERN]..." >&2
  echo 'Disable a local Linux account.' >&2
  echo '  -d: Deletes accounts' >&2
  echo '  -r: Removes the home directory' >&2
  echo '  -a: Creates an archive of the home directory for the account' >&2
  exit 1
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run with sudo or root vrivileges" >&2
  exit 1
fi

# Parse the options.
while getopts dra OPTION
do
  case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='-r' ;;
    a) ARCHIVE='true' ;;
    ?) usage ;;
  esac
done

# Remove the options while leaving the remaining arguments.
shift "$((OPTIND-1))"
#echo "${@}"

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do
  echo "Processing user: ${USERNAME}" 

  # Make sure the UID of the account is at least 1000.
  USERID="$(id -u ${USERNAME})"
  if [[ "${USERID}" -lt 1001 ]]
    then 
    echo "Refusing to remove the ${USERNAME} with UID ${USERID}" >&2
    exit 1
  fi

  # Create an archive if requested to do so.
  if [[ ${ARCHIVE} = 'true' ]]
  then
  # Make sure the ARCHIVE_DIR directory exists.
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory!!!"
      mkdir -p ${ARCHIVE_DIR}
      if [[ "${?}" -ne 0 ]]
        then
        echo "The archive directory ${ARCHIVE_DIR} could not be created !!" >&2
      fi
      exit 1
    fi
  fi
  
# Archive the user's home directory and move it into the ARCHIVE_DIR
  HOME_DIR="/home/${USERNAME}"
  ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
  if [[ -d ${HOME_DIR} ]]
  then
    echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
    tar -zcvf ${ARCHIVE_FILE} ${HOME_DIR} &>/dev/null
    if [[ "${?}" -ne 0 ]]
    then
      echo "Could not create ${ARCHIVE_FILE}" >&2
      exit 1
    fi
  else
    echo "${HOME_DIR} does not exist or is not a directory" >&2
    exit 1
  fi

# Delete the user.
  if [[ "${DELETE_USER}" = 'true' ]]
    then
    userdel ${REMOVE_OPTION} ${USERNAME}

# Check to see if the userdel command succeeded.
# We don't want to tell the user that an account was deleted when it hasn't been.
   if [[ "${?}" -ne 0 ]]
    then
      echo "The account ${USERNAME} not deleted!!" >&2
      exit 1
   fi
   echo "The account ${USERNAME} deleted!!" 
  else
    chage -E 0 ${USERNAME}
# Check to see if the chage command succeeded.
# We don't want to tell the user that an account was disabled when it hasn't been.
    if [[ "${?}" -ne 0 ]]
      then
      echo "The account ${USERNAME} not deleted" >&2
      exit 1
    fi
    echo "The account ${USERNAME} disabled"    
  fi
done
exit 0
