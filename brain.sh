#!/bin/bash

# import functions
source ./funcs/provision-ec2s.sh
source ./funcs/deployK8sRemotely.sh
source ./funcs/destroy_et.sh

# all nodes must be the same user and have the same key
user_name="ubuntu"
# enter keypath but without .pem
key_name="my_key"

update_config_after_provision() {
  master_ip=$(echo $master_ip | tr -d '"')
  worker1_ip=$(echo $worker1_ip | tr -d '"')
  worker2_ip=$(echo $worker2_ip | tr -d '"')
  # update hosts file with the ips of the nodes
  sed -i "s/MASTER_IP/${master_ip}/g" ansible/inventory.ini
  sed -i "s/WORKER_01_IP/${worker1_ip}/g" ansible/inventory.ini
  sed -i "s/WORKER_02_IP/${worker2_ip}/g" ansible/inventory.ini
}

if [ $# -eq 0 ]; then
  echo """No argument supplied. Use:
-t/--terraform for remote k8s deployment.
-l/--local for local k8s deployment.
-d/--delete to delete everything created.
--debug to debug everyline of code."""
  exit 1

elif [[  $2 == '--debug' ]]; then
  set -x

elif [ "$1" == '-t' ] || [ "$1" == '--terraform' ]; then
  provision-ec2s apply # we get three vars from that func: $master_ip $worker1_ip $worker2_ip
  if [ -z "$master_ip" ]; then
    echo "master_ip is empty"
    exit 1
  fi
  update_config_after_provision
  deployK8sRemotely
  sleep 15
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/playbook.yml \
    -e "master_ip=${master_ip}" -e "ansible_user=${user_name}" \
    -e "ansible_ssh_private_key_file=ansible/${key_name}.pem"
  # Check exit status
  if [ ! $? -eq 0 ]; then
      echo "Playbook execution failed."
      exit 1
  fi

elif [ "$1" == '-l' ] || [ "$1" == '--local' ]; then
  master_ip=$(cat ansible/inventory.ini | grep master -a1 | awk 'NR==3')
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/playbook.yml \
    -e "master_ip=${master_ip}" -e "ansible_user=${user_name}" \
    -e "ansible_ssh_private_key_file=ansible/${key_name}.pem"
  # Check exit status
  if [ ! $? -eq 0 ]; then
      echo "Playbook execution failed."
      exit 1
  fi

elif [ "$1" == '-d' ] || [ "$1" == '--delete' ]; then
  destroy_et
  exit 1

else
  echo """Invalid option. Use: 
-t/--terraform for remote k8s deployment.
-l/--local for local k8s deployment.
-d/--delete to delete everything created.
--debug to debug everyline of code."""
  exit 1
fi

ssh -i ansible/${key_name}.pem $user_name@$master_ip
