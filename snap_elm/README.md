Snap + Elm

Vagrant on Windows has an issue with chef.
https://github.com/mitchellh/vagrant/pull/2458
The file to modify for me was at "C:\HashiCorp\Vagrant\embedded\gems\gems\vagrant-1.4.1\plugins\provisioners\chef\provisioner\chef_solo.rb"
It should look like this.
      if !@machine.env.ui.is_a?(Vagrant::UI::Colored) && !Vagrant::Util::Platform.windows?
        options << "--no-color"
      end

The box pointed at is using an older version of the guest additions. Updating it at boot is simple.
    vagrant plugin install vagrant-vbguest
http://stackoverflow.com/questions/20022110/chef-fails-to-run-because-cookbooks-folder-is-not-accessible
