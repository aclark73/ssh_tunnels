# ssh_tunnels

Shell code to easily create and use SSH tunnels

## scenario

There are any number of machines inside the network that you may need to access.  You have ssh access to a gateway machine, which in turn has access inside the network.

## ssh tunnels

An SSH tunnel provides secure access to the internal machine.  I can never remember how to set them up, and anyway I want:

* Stable config, the SSH tunnel to server xyz should always use the same settings
* A "suite" of definitions and behavior, to use a tunnel you need to know its settings

So in this code you define a gateway server:

    ssht_gateway_userhost='user@gateway.domain.org'

Then define a tunnel named "box1" mapping localhost:2222 to box1.domain.org:22, which you log into as "someuser"

    ssht_define box1 box1.domain.org 2222 22 someuser

Now you have a command that will SSH to the box, setting up the tunnel as needed:

    ssht_box1_ssh
    
You also have variables you can use with SCP:

    scp -P $ssht_box1_port $ssht_box1_userhost:/remote/file /save/locally

### web tunnels

One really handy use for SSH tunnels is for internal web servers:

    ssht_define ws1 ws1.internal.domain.org 8180 80
    ssht_ws1_tunnel

Now you can access ws1 directly at http://localhost:8180/.

Directly monitor each server in a cluster:

    ssht_define ws1 ws1.internal.domain.org 8180 80
    ssht_define ws2 ws2.internal.domain.org 8280 80
    ssht_define ws3 ws3.internal.domain.org 8380 80

Easy!
