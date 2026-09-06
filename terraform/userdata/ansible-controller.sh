#!/bin/bash
set -e

apt-get update -y
apt-get install -y ansible python3-pip python3-boto3

# Sambungan Ansible guna SSM connection plugin - perlukan collection community.aws
ansible-galaxy collection install community.aws -p /usr/share/ansible/collections

# Dynamic inventory plugin AWS EC2 - auto-detect node guna tag "Role: devops-node"
# supaya tak perlu hardcode instance ID yang tak diketahui semasa provision.
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

[inventory]
enable_plugins = aws_ec2
EOF

chmod 644 /etc/ansible/inventory/aws_ec2.yml /etc/ansible/ansible.cfg
