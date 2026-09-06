#!/bin/bash
apt-get update -y
apt-get install -y ansible

mkdir -p /home/ubuntu/.ssh
aws ssm get-parameter --name /ansible/ssh-key --with-decryption \
  --query 'Parameter.Value' --output text > /home/ubuntu/.ssh/ansible_key
chmod 600 /home/ubuntu/.ssh/ansible_key
chown ubuntu:ubuntu /home/ubuntu/.ssh/ansible_key

cat > /etc/ansible/hosts <<'EOF'
[nodes]
web_server ansible_host=10.0.0.5
monitoring_server ansible_host=10.0.0.136

[nodes:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/.ssh/ansible_key
EOF

chmod 644 /etc/ansible/hosts

cat > /etc/ansible/ansible.cfg <<'EOF'
[defaults]
inventory = /etc/ansible/hosts
host_key_checking = False
EOF