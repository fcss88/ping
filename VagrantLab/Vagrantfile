Vagrant.configure("2") do |config|

config.vm.define "vm1" do |vm1|
    vm1.vm.provider "virtualbox" do |vb_vm1|
    vb_vm1.memory = 1024
    vb_vm1.cpus = 1
end

vm1.vm.box = "generic-x32/debian11"
vm1.vm.hostname = "okury"
vm1.vm.network "private_network", ip: "192.168.1.10"
    end

  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "generic-x32/debian11"
    vm2.vm.hostname = "ozasl"
    vm2.vm.network "private_network", ip: "192.168.1.11"
  end

end
