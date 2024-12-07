# Project

## Phase 1

This phase was deticated to implementing shell scripts to configure both a server and new incoming users. The configuration is done automatically through running the client.sh and server.sh scripts. 

In the process configuring and performing the following: 
- Checking for each package used if it's installed and installing it
- Creating a client
- NGNIX
- SSH
- Performing a network map
- Mosh
- Web server
- Client website
 
## Phase 2

We designed and implemented a chat room server that allows users to create and join multiple rooms simultaneously. The server includes user-friendly commands to ensure interactions are simple and intuitive. To enhance reliability and efficiency, we utilized synchronized methods along with lists and maps for managing users and rooms effectively.
 
## Team
 
- Mohamed Elansari [me2209852@student.qu.edu.qa]
- Khaled Qarawi [kq2203776@student.qu.edu.qa]
- Faisal Almalk [fa2203280@student.qu.edu.qa]
- Abdulrahman Shabban [as2204435@student.qu.edu.qa]

### Challenges

1. Adapting to new tools and technologies.
2. Mastering the syntax and logic of shell scripting.
3. Effectively using Git in the command line interface (CLI).
4. Designing a scalable and efficient architecture for the chat server.
5. Understanding the application's architecture for Phase 2 and how it integrates with other components.

### Issues

1. Difficulty in installing and configuring the Fedora Server.
2. Client tickets are saved only upon termination instead of during runtime.
3. Occasionally, the full list of connected users fails to display.
4. The program runs correctly only in the IDE console, not in standalone environments ie. terminal.


 
## Contributions
 
| Member |       Date | Description |
| :----- | ---------: | :---------- |
| Mohmaed| 2024-11-25 | Created the check install script            |
| Mohamed   | 2024-11-25 |  Created the password gen script           |
| Mohamed   | 2024-11-25 |  Created the create user script         |
| Mohmaed   | 2024-11-25 |  Created the config-sshd functionality           |
| Mohamed   | 2024-11-25 |  Created the mobile shell scripts           |
| Mohamed   | 2024-11-25 |  Created the ngnix web server           |
| Mohamed   | 2024-11-25 |  Created the client website creation           |
| Faisal   | 2024-11-27 |  Finished client remote testing           |
| Faisal   | 2024-11-28 |  Finished client create key script		|
| Faisal   | 2024-11-28 |  Some modification to some of the files created earlier	|
| Faisal   | 2024-11-28 |  Added setup-auth.sh	|
| Abdulrahman | 2024-11-29 | Added the script for test-web.sh |
| Abdulrahman | 2024-11-29 | Added the script for init-site.sh |
| khaled | 2024-11-29 | Added the script for exec-map.sh |
| Abdulrahman | 2024-11-29 | Added the script for site building and snchronization |
| khaled | 2024-11-30 | Added the script for fetch-info.sh |
| khaled | 2024-11-30 | Added the script for server.sh |
| khaled | 2024-11-30 | Added the script for client.sh |






 
## References
 
- [Linux start sshd](https://www.cyberciti.biz/faq/linux-start-sshd-openssh-server-command/) used to know how to start an sshd server.
- [Mosh org](https://mosh.org/) Understanding what mosh is and how it works.
- [Nginx guide](https://nginx.org/en/docs/beginners_guide.html) used this guide to lear more about nginx.
- [Add users](https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/)
- [Grep guide](https://stackoverflow.com/questions/10358547/how-to-grep-for-contents-after-pattern) Used to take part of the config file.
- [Generate SSH Keys](https://www.unixtutorial.org/how-to-generate-ed25519-ssh-key/)
- [Redirect to /dev/null](https://unix.stackexchange.com/questions/119648/redirecting-to-dev-null) Used to redirect both stdout and stderror to /dev/null
- [Fix problem with scripts](https://askubuntu.com/questions/74780/how-to-execute-a-script-in-a-different-directory-than-the-current-one) Fixed a problem where calling a script didn't change working directory to script location.
- [Check command status](https://askubuntu.com/questions/29370/how-to-check-if-a-command-succeeded) Check command exit status within the script.
- [Upload SSH key](https://stackoverflow.com/questions/18690691/how-to-add-a-ssh-key-to-remote-server) Upload the public key of client user to SSH server
- [Curl guide](https://curl.se/docs/manual.html) Understanding curl and using it to check server availability.
- [W3m manual](https://linux.die.net/man/1/w3m) Guidance for using w3m to load webpages.
- [Hugo Quick start](https://gohugo.io/getting-started/quick-start/) Used to initialize and build the Hugo site.
- [Rsync command guide](https://linuxize.com/post/how-to-use-rsync-for-local-and-remote-data-transfer-and-synchronization/) Command guide to using rsync for synchronization.
- [Fastfetch repo](https://github.com/fastfetch-cli/fastfetch) Documentation and repo of fastfetch
https://stackoverflow.com/questions/20389799/using-output-of-awk-to-run-command
https://stackoverflow.com/questions/13322485/how-to-get-the-primary-ip-address-of-the-local-machine-on-linux-and-os-x
https://stackoverflow.com/questions/34360943/check-if-ssh-connection-is-possible-when-it-needs-a-password?rq=3
https://mosh.org/

