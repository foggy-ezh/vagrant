#!/bin/bash
sudo -su root
if [ ! -d /apps/tomcat ]; then
	mkdir -p /apps/tomcat
fi
cd /apps/tomcat

if [ ! -d /apps/tomcat/apache-tomcat-8.5.9 ]; then
	tar xvf /vagrant/apache-tomcat-8.5.9.tar.gz 
#sed -i 's/Server port=\"8005\" shutdown=\"SHUTDOWN\"/Server port=\"9'$i'10\" shutdown=\"SHUTDOWN\"/' apache-tomcat-8.5.9/conf/server.xml 
#sed -i 's/Connector port=\"8080\" protocol=\"HTTP/Connector port=\"9'$i'11\" protocol=\"HTTP/' apache-tomcat-8.5.9/conf/server.xml 
#sed -i 's/Connector port=\"8009\" protocol=\"AJP/Connector port=\"9'$i'12\" protocol=\"AJP/' apache-tomcat-8.5.9/conf/server.xml 
fi
yum install -y java-11-openjdk.x86_64

if [ ! -f /etc/systemd/system/tomcat.service ]; then
	cat <<EOT >> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat - instance $i
After=network.target

[Service]
Type=forking

#User=tomcat
#Group=tomcat


Environment="JAVA_HOME=//usr/lib/jvm/java-11-openjdk-11.0.1.13-3.el7_6.x86_64/
Environment="CATALINA_PID=/apps/tomcat/apache-tomcat-8.5.9/run/tomcat.pid"
Environment="CATALINA_BASE=/apps/tomcat/apache-tomcat-8.5.9/"
Environment="CATALINA_HOME=/apps/tomcat/apache-tomcat-8.5.9/"

ExecStart=/apps/tomcat/apache-tomcat-8.5.9/bin/startup.sh
ExecStop=/apps/tomcat/apache-tomcat-8.5.9/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOT
fi
systemctl daemon-reload
chmod +x /apps/tomcat/apache-tomcat-8.5.9/bin/*.sh
systemctl enable tomcat
systemctl start tomcat
