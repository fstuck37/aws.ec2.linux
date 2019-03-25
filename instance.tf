##################################################
# File: instance.tf                              #
# Created Date: 04042017                         #
# Author: Fred Stuck                             #
# Version: 0.1                                   #
# Description: Creates a Test Instance           #
#                                                #
# Change History:                                #
# 04042017: Initial File                         #
#                                                #
##################################################

/* define am AWS Instances */
resource "aws_instance" "instance" {
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  
  vpc_security_group_ids = ["${length(var.security_group_ids) == 0 ? aws_security_group.security_group.*.id : var.security_group_ids}"]
  user_data = "${data.template_file.testbox_shell_script.rendered}"

  ami = "${var.amis[var.region]}"

  tags = "${merge(var.tags,map("Name",format("%s", var.server_name)))}"
}


resource "aws_security_group" "security_group" {
  count = "${ length(var.security_group_ids) == 0 ? 1 : 0}"
  name = "sg-${var.server_name}"
  description = "Security Rule Set for instance"
  vpc_id = "${var.vpc_id}"
  tags = "${merge( var.tags,map("Name",format("%s",var.server_name)))}"
 
 ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "testbox_shell_script" {
  template = <<-EOF
#!/bin/bash -x
SCRIPT_LOG='/var/log/build.log';
touch $SCRIPT_LOG; 
date >> $SCRIPT_LOG
echo "Starting Build Process" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Installing packages" >> $SCRIPT_LOG; 
yum -y install -y epel-release &>> $SCRIPT_LOG; 
yum -y install https://centos7.iuscommunity.org/ius-release.rpm &>> $SCRIPT_LOG; 
yum -y install wget.x86_64 nano.x86_64 traceroute.x86_64 bind-utils.x86_64 telnet.x86_64 nmap-ncat.x86_64 nmap.x86_64 mlocate.x86_64 jq.x86_64 rubygems.noarch centos-release-scl unzip.x86_64 git git.x86_64 iperf.x86_64 &>> $SCRIPT_LOG; 
yum -y install python36u python36u-devel python36u-pip python34-setuptools &>> $SCRIPT_LOG; 
date >> $SCRIPT_LOG
echo "Finished Installing packages" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Install AWS CLI" >> $SCRIPT_LOG; 
easy_install-3.4 pip  &>> $SCRIPT_LOG; 
pip3 install awscli --ignore-installed &>> $SCRIPT_LOG; 
mkdir /root/.aws
mkdir /home/centos/.aws
echo "[default]" > /root/.aws/credentials; 
echo "aws_access_key_id=${var.access_key}" >> /root/.aws/credentials
echo "aws_secret_access_key=${var.secret_key}" >> /root/.aws/credentials
echo "region=${var.region}" >> /root/.aws/credentials
echo "[default]" > /home/centos/.aws/credentials; 
echo "aws_access_key_id=${var.access_key}" >> /home/centos/.aws/credentials
echo "aws_secret_access_key=${var.secret_key}" >> /home/centos/.aws/credentials
echo "region=${var.region}" >> /home/centos/.aws/credentials
date >> $SCRIPT_LOG
echo "Finished install AWS CLI" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Download Terraform and Packer" >> $SCRIPT_LOG; 
terraform_url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{terraform}' | egrep "http.*linux.*64" | sort --version-sort -r  | head -1 | awk -F[\"] '{print $4}')
packer_url=$(curl --silent https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "http.*linux.*64" | sort --version-sort -r  | head -1 | awk -F[\"] '{print $4}')
mkdir /root/packer
mkdir /root/terraform
cd /root/terraform
curl -o terraform.zip $terraform_url &>> $SCRIPT_LOG;
unzip -qq terraform.zip &>> $SCRIPT_LOG;
cp /root/terraform/terraform /usr/bin/terraform
cd /root/packer
curl -o packer.zip $packer_url &>> $SCRIPT_LOG;
unzip -qq packer.zip &>> $SCRIPT_LOG;
cp /root/packer/packer /usr/bin/packer
date >> $SCRIPT_LOG
echo "Finished downloading Terraform and Packer" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Install Terraforming" >> $SCRIPT_LOG; 
ruby -v &>> $SCRIPT_LOG;
yum-config-manager --enable rhel-server-rhscl-7-rpms &>> $SCRIPT_LOG;
yum -y install rh-ruby23 &>> $SCRIPT_LOG;
scl enable rh-ruby23 bash &>> $SCRIPT_LOG;
ruby -v &>> $SCRIPT_LOG;
gem install terraforming &>> $SCRIPT_LOG;
echo "source scl_source enable rh-ruby23" >> /etc/skel/.bash_profile
echo "source scl_source enable rh-ruby23" >> /home/centos/.bash_profile
echo "source scl_source enable rh-ruby23" >> /root/.bash_profile
date >> $SCRIPT_LOG
echo "Finished Installing Terraforming" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Install Go" >> $SCRIPT_LOG; 
wget https://storage.googleapis.com/golang/${var.go_file}
tar -C /usr/local -xzf ${var.go_file}
echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/path.sh
chmod +x /etc/profile.d/path.sh
date >> $SCRIPT_LOG
echo "Finished Installing Go" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Running updatedb" >> $SCRIPT_LOG; 
updatedb &>> $SCRIPT_LOG; 
date >> $SCRIPT_LOG
echo "Finished running updatedb" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Running yum update -y" >> $SCRIPT_LOG; 
yum update -y &>> $SCRIPT_LOG; 
date >> $SCRIPT_LOG
echo "Finished running yum update -y" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Running updatedb again" >> $SCRIPT_LOG; 
updatedb &>> $SCRIPT_LOG; 
date >> $SCRIPT_LOG
echo "Finished running updatedb the second time" >> $SCRIPT_LOG; 

date >> $SCRIPT_LOG
echo "Finished Build Process" >> $SCRIPT_LOG;
  EOF
}