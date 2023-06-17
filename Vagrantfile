# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = "bento/ubuntu-20.04"
NODE_COUNT = 2

# https://githubmemory.com/repo/hashicorp/vagrant/issues/12553
$VM_nm="21"

Vagrant.configure("2") do |config|

  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |subconfig|
      subconfig.vm.box = BOX_IMAGE
      subconfig.vm.hostname = "node#{i}"
      subconfig.vm.network "private_network",
                        ip:"192.168.56.#{i + 10}",
                        netmask:$vm_nm
    end
  end
 

config.vm.provision "shell", inline: <<-SHELL
  for i in {1..#{NODE_COUNT}}; do 
      echo "192.168.56.$((i+10))\tnode${i}">>/etc/hosts
  done
  
  # Give scripts execute rights and activate cronjobs running every minute
  chmod +x /vagrant/login_tracking.sh
  chmod +x /vagrant/automatic_ssh_login.sh
  login_cron="* * * * * /vagrant/login_tracking.sh"
  ssh_cron="* * * * * /vagrant/automatic_ssh_login.sh"
  new_crontab="${login_cron}\n${ssh_cron}"
  echo -e "${new_crontab}" | crontab -  

SHELL
  
  # Install beforehand with "vagrant plugin install vagrant-timezone"
  config.timezone.value = :host
	
end

 
