#!/bin/sh

# Disable periodic updates - https://github.com/chef/bento/issues/609
sudo systemctl disable apt-daily.timer
sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service

# Wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

sudo add-apt-repository ppa:certbot/certbot
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y install ansible certbot git jq libyaml-dev nfs-common python-pip unzip
sudo pip install --upgrade pip
sudo pip install boto

# Install awscli using a roundabout way due to https://github.com/boto/botocore/issues/1258
sudo curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip"
sudo unzip /tmp/awscli-bundle.zip -d /tmp
sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
sudo ln -s /usr/local/bin/aws /usr/bin/aws

# Install awslogs
export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)
sudo curl "https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py" -o "/tmp/awslogs-agent-setup.py"
sudo cp -f /etc/issue /etc/issue.orig
sudo sh -c 'cat /etc/issue.net > /etc/issue'
sudo sed -i 's/$ActionFileDefaultTemplate/#$ActionFileDefaultTemplate/g' /etc/rsyslog.conf
sudo /etc/init.d/rsyslog restart
sudo sh -c "python /tmp/awslogs-agent-setup.py --region $AWS_REGION --configfile=/tmp/awslogs.conf --non-interactive"

# Fix /etc/rc.local
sudo diff /etc/rc.local /tmp/rc.local
sudo cp -f /etc/rc.local /etc/rc.local.orig
sudo cp -f /tmp/rc.local /etc/rc.local

# Setup logrotate
sudo cp -f /tmp/logrotate.config /etc/logrotate.d/openvpnas

echo "DONE"
