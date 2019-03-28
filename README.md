AWS Instance
=============

This module deploys an AWS Instance.

Example
------------
```
module "testbox" {
  source      = "git::https://github.com/fstuck37/aws.ec2.linux.git"
  region      = "us-east-1"
  subnet_id   = "subnet-1234567890abcdef1"
  key_name    = "${aws_key_pair.testbox-key.key_name}"
  server_name = "test37"
  vpc_id      = "vpc-1234567890abcdef1"
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
}

resource "aws_key_pair" "testbox-key" {
  key_name_prefix = "test-key"
  public_key      = "${file(var.public_key_file)}"
}

variable "public_key_file" {
  default = "C:\\PubKey.pem"
}

variable "tags" {
  type = "map"
  default = {
    dept = "Development"
    Billing = "12345"
    Contact = "F. Stuck"
    Environment = "POC"
    Notes  = "This is a test environment"
  }
}

```

Argument Reference
------------

* **Base Settings**
   * **region** - Required : The AWS Region to deploy the VPC to. For example us-east-1
   * **vpc_id** - Required : The VPC ID to deploy the instance.
   * **subnet_id** - Required : The Subnet ID to deploy the instance on.
   * **key_name** - Required : The key name of the Key Pair to use for the instance; which can be managed using the aws_key_pair resource.
   * **server_name** - Required : The name of the instance.
   * **security_group_ids** - Optional : List of Security Group ID Numbers to apply to the instance. If none are provided one will be created that allows all IP both ingress and egress. It is recommended to add at least one security group that allows only appropriate traffic.
   * **access_key** - Optional : Aws access key to configure the .aws/credentials file.
   * **secret_key** - Optional : The secret key to configure the .aws/credentials file.
   * **amis** - Optional : Map of aws regions to instrance AMIs.
   * **go_file** - Optional : The file to download to install Go programming language. The default is go1.12.1.linux-amd64.tar.gz.
   * **instance_type** - Optional : The Instance Type, the defualt is a t2.micro.
   * **associate_public_ip_address** - Optional : create a public IP address to the instance. The default is false.
   * **tags** - Optional : A map of tags to assign to the resource.  

Output Reference
------------
   * **id** - The instance ID
   * **private_dns** - The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC 
   * **private_ip** - The private IP address assigned to the instance
   * **public_ip** - The public IP address assigned to the instance, if applicable.
   * **public_dns** - The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC