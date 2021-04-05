# Requirements
### 1. Privileges
* Enforces that it be executed with superuser (root) privileges. <br />
* If the script is not executed with superuser privileges it will not attempt to create a user and returns an exit status of 1. 
* All messages associated with this event will be displayed on standard error.

### 2. Usage Statement
* Provides a usage statement much like you would find in a man page if the user does not supply an account name on the command line and returns an exit status of 1. 
* All messages associated with this event will be displayed on standard error.
* Messages:
  * Disables (expires/locks) accounts by default.
  * Allows the user to specify the following options:
  * -d: Deletes accounts instead of disabling them.
  * -r: Removes the home directory associated with the account(s). `userdel -r` 
  * -a: Creates an archive of the home directory associated with the accounts(s) and storesthe archive in the /archives directory. 
    - (NOTE: /archives is not a directory that exists by default on a Linux system. The script will need to create this directory if it does not exist.)
  * ? :Any other option will cause the script to display a usage statement and exit with an exit status of 1.

### 3. Parse the Options
* Accepts a list of usernames as arguments. 
* At least one username is required or the script will display a usage statement much like you would find in a man page and return an exit status of 1.
* All messages associated with this event will be displayed on standard error.
 - ARCHIVE_DIR='/archive'

### 4. Loop through all the username supplied as args
* Refuses to disable or delete any accounts that have a UID less than 1,000. 
  - USERID="$(id -u ${USERNAME})"
* Create an archive if requested to do so.
* Make sure the ARCHIVE_DIR directory exists.
* Archive the user's home directory and move it into the ARCHIVE_DIR
  - HOME_DIR="/home/${USERNAME}"
  - ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
* Delete the user if the option is -d, else disable the user
* Delete the user's Home dir if -r option is added.

### 5. Informs the user if the account was not able to be disabled, deleted, or archived for some reason.
