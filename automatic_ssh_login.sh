#!/bin/bash

host=$(hostname)
users=("serval" "bengal")
current_user=""
ssh_node=""

# Determine user and ssh node based on current host node
if [ "$host" = "node1" ]; then
  current_user=${users[0]}
  ssh_node="node2"
elif [ "$host" = "node2" ]; then
  current_user=${users[1]}
  ssh_node="node1"
else
  echo "Script is running on a node not accounted for..."
  exit 1
fi

# Login into correct user and ssh to target node
echo $current_user
su -c "ssh $ssh_node" $current_user
