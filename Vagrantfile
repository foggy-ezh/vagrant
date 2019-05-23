Vagrant.configure("2") do |config|
	box = "sbeliakou/centos"
	(1..2).each do |i|
		config.vm.define "tomcat-#{i}" do |node|
			node.vm.box = "#{box}"
			node.vm.hostname = "tomcat-#{i}"
			node.vm.network "private_network", ip: "192.168.56.#{i+5}"
			node.vm.provision "shell", :path => "prov_tomcat.sh", :args => "#{i+5}"
			node.vm.provider :virtualbox do |v|
				v.memory = 2048
			end
		end	
	end

	config.vm.define "lb" do |node|
		node.vm.box = "#{box}"
		node.vm.hostname = "lb"
		node.vm.network "private_network", ip: "192.168.56.105"
        	node.vm.provider :virtualbox do |v|
			v.memory = 1024
		 node.vm.provision "shell", path: "prov_apache.sh"
		end
        end 
end
