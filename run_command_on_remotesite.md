#Configure SSH Authentication
1. Create an SSH Key pair on the main server and accept all the default.</br>
`ssh-keygen` 
2. add serverNN in `/etc/hosts` 
3. Copy the publice key to all the remote servers. </br>
`ssh-copy-id serverNN`
4. Test</br>
`ssh-keygen` </br>
`ssh-copy-id server02`</br>
Are you sure you want to continue connecting (yes/no)? `yes` </br>
vagrant@server02's password: `ENTER PASSWORD` </br>
Number of key(s) added: 1</br>
vagrant@server01:~/.ssh$`ssh server02 hostname`</br>
server02</br>

# Requirements
### 1. Provide server list
Executes all arguments as a single command on every server listed in the `/vagrant/servers` file by default.

### 2. Command
Executes the provided command as the user executing the script.

### 3. SSH Option
Use `ssh -o ConnectTimeout=2` to connect to a host. </br>
This way if a host is down, the script doesn't hang for more than 2 seconds per down server.

### 4. Usage Statement
* Provides a usage statement much like you would find in a man page and returns an exit status of 1. 
* All messages associated with this event will be displayed on standard error.
* Messages:
  * `-f FILE`: This allows the user to override the default file of `/vagrant/servers`. </br>
             - This way they can create their own list of servers execute commands against that list.
  * `-n     `: allows the user to perform a "dry run" where the commands will be displayed instead of executed.  </br>
              Precede each command that would have been executed with `DRY RUN:`
  * `-s     `: Run the command with sudo (superuser) privileges on the remote servers.    
  * `-v     `: Enable verbose mode, which displays the name of the server for which the command is being executed on.
  * `?      `: Any other option will cause the script to display a usage statement and exit with an exit status of 1.

### 5. Privileges
* Enforces that it be executed without superuser (root) privileges. 
* If the user wants the remote commands executed with superuser (root) privileges, they are to specify the `-s` option.

### 6. On SSH Failure
* Informs the user if the command was not able to be executed successfully on a remote host.

### 7. Exit Status
* Exits with an exit status of 0 or the most recent non-zero exit status of the ssh command.
