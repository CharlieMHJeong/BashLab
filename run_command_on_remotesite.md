#Configure SSH Authentication
1. Create an SSH Key pair on the main server and accept all the default.
`ssh-keygen` 
2. add serverNN in `/etc/hosts` 
3. Copy the publice key to all the remote servers. 
`ssh-copy-id serverNN`
4. Test
vagrant@server01:~/.ssh$ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/vagrant/.ssh/id_rsa.
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:chjL0aDpFQmumbfQR4Tg5j7BHIKgdgG5BsID0W1XnvE vagrant@server01
The key's randomart image is:
+---[RSA 2048]----+
|*+++.o+oo        |
|*=..=+o= +       |
|*.*o+.= + E      |
|.O.B + =         |
|. X + * S        |
| . + o o         |
|  o .            |
|   .             |
|                 |
+----[SHA256]-----+
07:28:04 vagrant@server01:~/.ssh$ssh-copy-id server02
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
The authenticity of host 'server02 (10.9.8.12)' can't be established.
ECDSA key fingerprint is SHA256:Fi4FisVgFyEkos9NgKz0q+zzZwe3+xhCHWGrXL+jZck.
ECDSA key fingerprint is MD5:b6:04:55:d7:db:3c:a8:a1:b6:f6:15:1f:be:7e:48:41.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@server02's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'server02'"
and check to make sure that only the key(s) you wanted were added.

07:28:21 vagrant@server01:~/.ssh$ssh server02 hostname
server02

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
