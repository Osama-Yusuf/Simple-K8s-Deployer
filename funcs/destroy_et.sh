destroy_et() {
  provision-ec2s destroy
  sed -i "s/${key_name}/KEY_NAME/g" terraform/variables.tf

  # Backup the original file
  # cp ansible/inventory.ini ansible/inventory.ini.bak
  rm -f ansible/token.txt

  # Define placeholders
  placeholders="[all]\nMASTER_IP\nWORKER_01_IP\nWORKER_02_IP\n\n[master]\nMASTER_IP\n\n[worker]\nWORKER_01_IP\nWORKER_02_IP\n"

  # Replace content in inventory file
  echo -e "$placeholders" > ansible/inventory.ini

  echo "config files updated with placeholders."
}