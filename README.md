# Tomcat-installation
this repository contains installation and configuration of tomcat.

Go through Tomcat_ubuntu.yml for tomcat installation on ubuntu.
Go through Tomcat_lin.yml for tomcat installation on Linux
Go through Tomcat.yml for tomcat installation on windows

step 1: Prapare config.ini set path for tomcat installer and tomcat directory, modified version name and jvm memory as per your requirements.

step 2: Run playbook 
  ansible-playbook Java_lin.yml -e "configFile=config.ini hosts=<host_name>" -i /etc/ansible/hosts -vvv
  
refer https://github.com/abhisheknanarkar24/Java-installation




