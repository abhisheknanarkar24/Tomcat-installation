#!/bin/bash
#####################################################################################
# Date            Version            Change
# 12/06/2019      2.0.1              Created (current)
#####################################################################################

#$1 = service_name
#$2 = port
#$3 = assets_dir
#$4 = tomcat_dir
#$5 = jvm_min
#$6 = jvm_max

touch /usr/lib/systemd/system/$1-$2.service
cat > "$3/$4/bin/setenv.sh" <<EOL
echo "[INFO] setting up ENV variables..."
export CATALINA_HOME=$3/$4
export CATALINA_BASE=$3/$4
export MYIP=`hostname -i`
export JAVA_OPTS="-Dcatalina.home=$3/$4 -Dcatalina.base=$3/$4 -Djava.endorsed.dirs=$3/$4/endorsed -Djava.io.tmpdir=$3/$4/temp -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.util.logging.config.file=$3/$4/conf/logging.properties  -Duser.timezone=GMT -Duser.displayTimezone=Europe/London -Djava.awt.headless=true  -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9091 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=$MYIP -XX:-OmitStackTraceInFastThrow"
echo "[INFO] set ENV variables : completed OK"
EOL


touch /usr/lib/systemd/system/$1-$2.service
cat > "/usr/lib/systemd/system/$1-$2.service" <<EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

#Environment=CATALINA_PID=$3/$4/temp/tomcat.pid
Environment=CATALINA_HOME=$3/$4
Environment=CATALINA_BASE=$3/$4
Environment='CATALINA_OPTS=-Xms$5M -Xmx$6M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'      
ExecStart=$3/$4/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL

chmod -R 750 "$3/$4/bin/startup.sh"
chmod -R 750 "$3/$4/bin/catalina.sh"

# Exposing the port to access Ensemble from remote machine
sudo firewall-cmd --zone=public --add-port="$2/tcp" --permanent
sudo firewall-cmd --reload
sudo systemctl daemon-reload
sudo systemctl enable "$1-$2"
sudo systemctl start "$1-$2"
sudo systemctl status "$1-$2"
