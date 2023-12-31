# Simple K8s Deployer
**Simple K8s Deployer** is a **BASH** script that can be used to provision 3 instances on aws with terraform then initialize the K3s cluster using ansible playbooks or initialize it on your on-prem/local VMs by adding your VMs IPs in the ansible/inventory.ini.

---

## Getting started:

### Prerequisites:
- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

### Install:
```
git clone https://github.com/Osama-Yusuf/Simple-K8s-Deployer.git
cd Simple-K8s-Deployer && chmod +x brain.sh 
```

### Usage:
``` bash
./brain.sh [OPTION]
   -t/--terraform for remote k8s deployment.
   -l/--local for local k8s deployment.
   -d/--delete to delete everything created.
   --debug to debug every line of code.
Example: ./brain.sh -t --debug
```

### Notes:
#### For terraform:
if you desire to provision it on aws with terraform you don't need to configure anything but if you want to change things around you can change the vars in brain.sh, terraform/variables.tf (DO NOT CHANGE THE KEY NAME IN THE terraform/variables.tf or it won't work, but you can change it in the brain.sh)

#### For on-prem/local:
Yet I haven't enhancd the code to accept multble keys for each vm, so it currently only work if all VMs are on the same user and key.
   A quick fix to that is to add your public key to your VMs, and with that it will work with just your private key or without mentioning anything.

#### For both:
   so far there must be only one master and two workers, i'm currently working on a enhancement for that, if you made any other configuration than this it won't work

---

## What it does:

### 1. Provisions 3 "t2.medium" ec2's using terraform
- #### Creates a new key and store it in local machine
- #### Creates a new vpc with one public subnet and sg for the ec2
- #### It creates 3 ec2's by for-looping these strings (master, worker1, worker2)

### 2. Then it initializes the cluster using the ansible playbooks by:
- #### install & initialize k3s
- #### then it creates the token file on the master node
- #### then it copies the token to the worker nodes and the workers join the cluster with the token and the master node ip 

### After execution 3 instances will be up & running on aws (master, worker1, & worker2) initialized with k3s & kubectl 
### Then it will ssh into master node for you to start working/studying k8s

---

## Tested Environments

* Ubuntu 22.04.
   If you have successfully tested this script on others systems or platforms please let me know!

---

## Support

 If you want to support this project, please consider donating:
 * PayPal: https://paypal.me/osamayousseff?country.x=EG&locale.x=en_US
 * Buy me a coffee: https://www.buymeacoffee.com/OsamaYusuf

---

* `By Osama-Yusuf`
* `Thanks for reading`

-------
##### Report bugs for "Kubernetes-Init-Cluster"
* `osama9mohamed5@gmail.com`
