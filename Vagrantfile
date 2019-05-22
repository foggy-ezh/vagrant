Vagrant.configure("2") do |config|
	box = "sbeliakou/centos"
	(1..2).each do |i|
		config.vm.define "tomcat.#{i}" do |node|
			node.vm.box = "#{box}"
			node.vm.hostname = "tomcat.#{i}"
			node.vm.network "private_network", ip: "192.168.56.#{i+1}"
			node.vm.provision "shell", path: "prov_tomcat.sh"
			node.vm.provider :virtualbox do |v|
				v.memory = 1024
			end
		end	
	end

	config.vm.define "apache.balancer" do |node|
		node.vm.box = "#{box}"
		node.vm.hostname = "apache.balancer"
		node.vm.network "private_network", ip: "192.168.56.101"
        	node.vm.provider :virtualbox do |v|
			v.memory = 1024
		 node.vm.provision "shell", path: "prov_apache.sh"
		end
        end 
end
