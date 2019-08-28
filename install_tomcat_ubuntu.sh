#!/bin/bash
#####################################################################################
# Date            Version            Change
# 13/05/2019      2.0.1              Created (current)
#####################################################################################

# $1 = service_name
# $2 = juddi_install_dir
# $3 = jvm_min
# $4 = jvm_max
# $5 = port

sudo touch /etc/systemd/system/$1-$5.service
#sudo cat > "$2/bin/setenv.sh" <<EOL
#echo "[INFO] setting up ENV variables..."
#export CATALINA_HOME=$2
#export CATALINA_BASE=$2
#export MYIP=`hostname -i`
#export JAVA_OPTS="-Dcatalina.home=$2 -Dcatalina.base=$2 -Djava.endorsed.dirs=$2/endorsed -Djava.io.tmpdir=$2/temp #-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager #-Djava.util.logging.config.file=$2/conf/logging.properties  -Duser.timezone=GMT -Duser.displayTimezone=Europe/London #-Djava.awt.headless=true  -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9091 #-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=$MYIP #-XX:-OmitStackTraceInFastThrow"
#echo "[INFO] set ENV variables : completed OK"
#EOL

sudo cat > "/etc/systemd/system/$1-$5.service" <<EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking
Environment=CATALINA_HOME=$2
Environment=CATALINA_BASE=$2
Environment='CATALINA_OPTS=-Xms$3M -Xmx$4M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
Environment='CLASSPATH=$2/bin/bootstrap.jar:$2/bin/tomcat-juli.jar'
ExecStart=$2/bin/startup.sh
ExecStop=$2/bin/shutdown.sh

User=$6
Group=$7
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL

sudo chmod -R 750 "$2/bin/startup.sh"
sudo chmod -R 750 "$2/bin/catalina.sh"

# Exposing the port to access Tomcat from remote machine
#sudo ufw allow "$5/tcp" 
#sudo ufw reload

sudo systemctl daemon-reload
sudo systemctl start "$1-$5"
sudo systemctl status "$1-$5"
