# maas-lxd
This is a simple project to provide MAAS with KVM POD capability in a LXD container.

## Getting Started
- LXD must be installed and working. [LXD Install Guide](https://linuxcontainers.org/lxd/getting-started-cli/)
- KVM must be installed and working. [KVM Install Guide](https://help.ubuntu.com/community/KVM/Installation)
- If running LXC version 3.0 or above, ensure that you have an LXD
  storage pool named "default" set up; this project assumes it is.

## Running
If using a version of lxd that supports storage pools (>2.0), ensure that the pool name in 'root-device' matches what you have in `lxc storage list`

Run the make-maas.sh and name your MAAS container.
```
./make-maas.sh maas
```
This applies the included profile to a container, tries to get it's IP address
and adds a dnsmasq entry to LXD so that containers which PXE will be sent to
MAAS. Note that DNS/DHCP is still done via LXD. If you are using the default NAT
configuration you'll be able to spin up KVM's inside this LXD container through
MAAS. If you're using a bridged network setup you'll need to handle network
configuration to address how you want DHCP/DNS/PXE to be routed.

The install can take some time as it has to install several packages. When it is
complete you can access your MAAS node at http://MAASIP:5240/MAAS

## Using MAAS
See the [MAAS Documentation](https://docs.ubuntu.com/maas/devel/en/) for up to
date information. A few quick comments
- An admin user has been setup, password/login are admin/admin
- You can use MAAS PODS, but one is not automatically added currently with this
  script. To do so run `create-vm-pod.sh $container-name` after MAAS is up and has 
  been configured with images. This will create a pod and an initial VM.

Once PODs are configured you can create them directly from the MAAS interface.
MAAS will also compose a pod for juju when juju requests a machine. However
automatic machine creation is currently not working https://bugs.launchpad.net/maas/+bug/1740935
on stable branches, it appears version 2.6 in development it is currently
working.


For more information on using Juju with MAAS see [Using a MAAS
cloud](https://jujucharms.com/docs/devel/clouds-maas) in the juju documentation.
