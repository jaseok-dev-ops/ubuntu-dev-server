# UBUNTU LOCAL DEVELOPMENT SERVER INSTALLATION SCRIPTS
This is a collection of bash scripts I wrote to quickly install and configure a basic development enviroment anytime I get a new computer system. This version is currently tested on Ubuntu 22.04 (Jammy)

## Getting Started
The initial development enviroment installs a default empty php/html site, a WordPress development site with and nginx reverse proxy.

### Add initial sites to /etc/hosts
```
127.0.0.1   localhost.com
127.0.0.1   wp.localhost.com
127.0.0.1   node.localhost.com
```
** NOTES FOR RUNNING THIS DEV ENVIRONMENT ON THE WINDOWS 10/11 LINUX SUB-SYSTEM
The host file should be edited in Windows as Ubuntu auto-generates the host file from the Windows host file. Restart the system after editing so Ubuntu can regenerate the host file from Windows.
