#!/bin/bash
set -e

apt-get update -y
apt-get install -y ansible python3-pip python3-boto3 git

# Komunikasi Ansible guna SSM connection plugin (community.aws) +
# deploy container guna community.docker + role galaxy geerlingguy.docker
ansible-galaxy collection install \
  community.aws \
  community.docker \
  -p /usr/share/ansible/collections

ansible-galaxy role install geerlingguy.docker -p /etc/ansible/roles

# ---------------- Inventory dinamik AWS EC2 ----------------
# Auto-detect node guna tag "Role: devops-node".
# ansible_connection=aws_ssm -> Ansible berhubung melalui AWS SSM,
# ansible_host = instance ID node.
mkdir -p /etc/ansible/inventory

cat > /etc/ansible/inventory/aws_ec2.yml <<'EOF'
plugin: aws_ec2
regions:
  - ap-southeast-1
filters:
  tag:Role:
    - devops-node
keyed_groups:
  - key: tags.Name
    prefix: ''
    separator: ''
compose:
  ansible_host: instance_id
  ansible_connection: aws_ssm
  ansible_aws_ssm_region: ap-southeast-1
EOF

cat > /etc/ansible/ansible.cfg <<'EOF'
[defaults]
inventory = /etc/ansible/inventory/aws_ec2.yml
host_key_checking = False
collections_paths = /usr/share/ansible/collections
roles_path = /opt/final-project/ansible/roles:/etc/ansible/roles

[inventory]
enable_plugins = aws_ec2
EOF

chmod 644 /etc/ansible/inventory/aws_ec2.yml /etc/ansible/ansible.cfg

# ---------------- Sumber playbook (git clone, idempotent) ----------------
# Repo project ini (public) - clone terus via HTTPS.
# Playbook dijalankan dari /opt/final-project/ansible.
if [ ! -d /opt/final-project/.git ]; then
  git clone https://github.com/azfarsyafiq/devops-bootcamp-final-project.git /opt/final-project
else
  git -C /opt/final-project pull
fi
git config --global --add safe.directory /opt/final-project