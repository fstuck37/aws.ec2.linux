variable "region"     { }

variable "vpc_id" { }

variable "subnet_id" { }

variable "key_name" { }

variable "server_name" { }

variable "security_group_ids" {
  description = "Optional : List of Security Group ID Numbers to apply to the instance. If none are provided one will be created that allows all IP both ingress and egress."
  default = []
}

variable "access_key" {
  default = "#########################"
}

variable "secret_key" {
  default = "#########################"
}

variable "amis" {
  type = map(string)
  description = "AWS AMIs based on Region"
  default = {
    us-east-1    = "ami-02eac2c0129f6376b"
    us-east-2    = "ami-0f2b4fc905b0bd1f1"
    us-west-1    = "ami-074e2d6769f445be5"
    us-west-2    = "ami-01ed306a12b7d1c96"
    ca-central-1 = "ami-033e6106180a626d0"
    eu-west-1    = "ami-04cf43aca3e6f3de3"
    eu-west-2    = "ami-0ff760d16d9497662"
    eu-central-1 = "ami-0eab3a90fc693af19"
  }
}

variable "go_file" {
  default = "go1.12.1.linux-amd64.tar.gz"
}

variable "instance_type"  { 
  description = "Optional : The Instance Type, the defualt is a t2.micro"
  default = "t2.micro"
}


variable "associate_public_ip_address"  { 
  description = "Optional : create a public IP address to the instance"
  default = false
}

variable "tags" {
type = map(string)
  description = "Optional : A map of tags to assign to the resource."  
  default = { }
}
