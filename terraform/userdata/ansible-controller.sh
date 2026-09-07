#!/bin/bash
set -e

apt-get update -y
apt-get install -y ansible python3-pip python3-boto3 git

# Session Manager plugin diperlukan oleh connection plugin aws_ssm
cd /tmp
curl -fsSL https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb -o session-manager-plugin.deb
dpkg -i session-manager-plugin.deb

# Komunikasi Ansible guna SSM connection plugin (community.aws) +
# deploy container guna community.docker + role galaxy geerlingguy.docker
ansible-galaxy collection install \
  community.aws \
  community.docker \
  -p /usr/share/ansible/collections

ansible-galaxy role install geerlingguy.docker -p /etc/ansible/roles

# ---------------- S3 bucket untuk aws_ssm file transfer ----------------
# Connection plugin aws_ssm memerlukan S3 bucket untuk hantar/terima fail.
BUCKET="devops-bootcamp-ssm-session-bucket"
aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1 \
  >/dev/null 2>&1 || true

# ---------------- Inventory dinamik AWS EC2 ----------------
# Auto-detect node guna tag "Role: devops-node".
# ansible_connection=aws_ssm -> Ansible berhubung melalui AWS SSM,
# ansible_host = instance ID node.
mkdir -p /etc/ansible/inventory

cat > /etc/ansible/inventory/aws_ec2.yml <<EOF
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
  ansible_aws_ssm_bucket_name: $BUCKET
EOF

cat > /etc/ansible/ansible.cfg <<'EOF'
[defaults]
inventory = /etc/ansible/inventory/aws_ec2.yml
host_key_checking = False
collections_path = /usr/share/ansible/collections
roles_path = /opt/final-project/ansible/roles:/etc/ansible/roles
deprecation_warnings = False

[inventory]
enable_plugins = aws_ec2
EOF

chmod 644 /etc/ansible/inventory/aws_ec2.yml /etc/ansible/ansible.cfg

# ---------------- Sumber playbook (git clone, idempotent) ----------------
# Repo project ini (public) - clone terus via HTTPS.
# Playbook dijalankan dari /opt/final-project/ansible.
if [ ! -d /opt/final-project/.git ]; then
  git clone https://github.com/azfarsyafiq/devops-bootcamp-project.git /opt/final-project
else
  git -C /opt/final-project pull
fi
git config --global --add safe.directory /opt/final-project