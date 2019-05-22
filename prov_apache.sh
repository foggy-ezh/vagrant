#!/bin/bash
sudo -su root

sudo yum -y update
sudo yum install -y net-tools
sudo yum install -y httpd

if [ ! -f /etc/httpd/conf/httpd-vhost.conf ]; then
	sudo touch /etc/httpd/conf/httpd-vhost.conf
	sudo cat << EOT >> /etc/httpd/conf/httpd-vhost.conf
		<VirtualHost *:80>
     		ServerName test.lab
        	ServerAlias *192.168.56.2/*, *127.0.0.1/*
        	DocumentRoot /var/www/html/
       		 <Proxy balancer://testlabcluster>
               		BalancerMember ajp://192.168.56.2:8009
                	BalancerMember ajp://192.168.56.3:8009
        	</Proxy>
        	ProxyPass /index.html balancer://testlabcluster/examples/index.html
        	<Location /balancer-manager>
                	SetHandler balancer-manager
               		Require all granted
        	</Location>

	</VirtualHost>
EOT
fi

sudo echo "IncludeOptional conf/httpd-vhost.conf" >> /etc/httpd/conf/httpd.conf
sudo echo "127.0.0.1 test.lab" >> /etc/hosts
sudo systemctl daemon-reload
sudo systemctl start httpd
sudo systemctl enable httpd

