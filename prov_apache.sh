#!/bin/bash
sudo -su root

sudo yum -y update
sudo yum install -y net-tools vim httpd

if [ ! -f /etc/httpd/conf/httpd-vhost.conf ]; then
	sudo touch /etc/httpd/conf/httpd-vhost.conf
	sudo cat << EOT >> /etc/httpd/conf/httpd-vhost.conf
<VirtualHost *:80>
        <Proxy "balancer://mycluster">
                BalancerMember "http://192.168.56.2:8080"
                BalancerMember "http://192.168.56.3:8080"
        </Proxy>
        ProxyPass        "/"  "balancer://mycluster/"
        ProxyPassReverse "/" "balancer://mycluster/"
</VirtualHost>

EOT
fi

sudo echo "IncludeOptional conf/httpd-vhost.conf" >> /etc/httpd/conf/httpd.conf
sudo systemctl daemon-reload
sudo systemctl start httpd
sudo systemctl enable httpd
