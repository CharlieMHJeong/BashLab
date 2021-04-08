# Requirements
### 1. Provide server list
Executes all arguments as a single command on every server listed in the /vagrant/servers file by default.

### 2. Command
Executes the provided command as the user executing the script.

### 3. SSH Option
Use "ssh -o ConnectTimeout=2" to connect to a host. </br>
This way if a host is down, the script doesn't hang for more than 2 seconds per down server.

### 4. Usage Statement
* Provides a usage statement much like you would find in a man page and returns an exit status of 1. 
* All messages associated with this event will be displayed on standard error.
* Messages:
  * -f FILE: This allows the user to override the default file of /vagrant/servers. 
           - This way they can create their own list of servers execute commands against that list.
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
