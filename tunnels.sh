# https://github.com/aclark73/ssh_tunnels

# Globals

# Default host domain (appended to one-word host names)
ssht_domain='.domain.org'

# Gateway server (what you can log into from outside)
ssht_gateway_userhost='user@gateway.domain.org'

# Gateway server port
ssht_gateway_port=22

# Default user for generated ssh command
ssht_ssh_user='user'

# Prefix for vars/aliases
ssht_prefix='ssht'

function ssht_host () {
	host=$1
	has_domain=`echo $host | grep '\.'`
	if [ -z "$has_domain" ]
	then
		host=$host$ssht_domain
	fi
	echo $host
}

function ssht_tunnel () {
	host=`ssht_host $1`
	port=$2
	remote_port=$3

	echo Tunneling to $host : $remote_port on $port 
	
	ps_found=`ps ax | grep ssh | grep "$port:$host"`
	if [ -z "$ps_found" ]
	then
		ssh -p $ssht_gateway_port -f $ssht_gateway_userhost -L $port:$host:$remote_port -N
	fi
}

function ssht_define () {
	name=$1
	host=$2
	port=$3
	remote_port=${4-22}
	user=${5-$ssht_ssh_user}

	full_host=`ssht_host $host`

	tunnel_cmd="ssht_tunnel $full_host $port $remote_port"
	ssh_cmd="$tunnel_cmd; ssh -p $port $user@localhost"

	# Shortcuts
	eval ${ssht_prefix}_${name}_userhost='$user@localhost'
	eval ${ssht_prefix}_${name}_port='$port'
	alias ${ssht_prefix}_${name}_tunnel="$tunnel_cmd"
	alias ${ssht_prefix}_${name}_ssh="$ssh_cmd"
}



# Define a tunnel, local port 2222 points to port 22 on box1
ssht_define box1 box1.internal.domain.org 2222 22 someuser
# SSH into the machine as someuser, opening the tunnel as needed
ssht_box1_ssh

# SCP files from the machine
scp -P $ssht_box1_port $ssht_box1_userhost:/remote/file /save/locally


# Map port 80 on each of several web servers to local port 8x80
# http://localhost:8180/some/url hits the server directly
ssht_define ws1 ws1.internal.domain.org 8180 80
ssht_define ws2 ws2.internal.domain.org 8280 80
ssht_define ws3 ws3.internal.domain.org 8380 80


