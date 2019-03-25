variable "region"     { }

variable "vpc_id" { }

variable "subnet_id" { }

variable "key_name" { }

variable "server_name" { }

variable "security_group_ids" {
  description = "Optional : List of Security Group ID Numbers to apply to the instance. If none are provided one will be created that allows all IP both ingress and egress.
  default = []
}

variable "access_key" {
  default = "#########################"
}

variable "secret_key" {
  default = "#########################"
}

variable "amis" {
  type = "map"
  description = "AWS AMIs based on Region"
  default = {
    us-east-1 = "ami-6d1c2007"
    us-east-2 = "ami-6a2d760f"
    us-west-1 = "ami-af4333cf"
    us-west-2 = "ami-d2c924b2"
    ca-central-1 = "ami-af62d0cb"
    eu-west-1 = "ami-7abd0209"
    eu-west-2 = "ami-bb373ddf"
    eu-central-1 = "ami-9bf712f4"
    ap-northeast-1 = "ami-eec1c380"
    ap-northeast-2 = "ami-c74789a9"
    ap-southeast-1 = "ami-f068a193"
    ap-southeast-2 = "ami-fedafc9d"
    ap-south-1 = "ami-95cda6fa"
    sa-east-1 = "ami-26b93b4a"
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
  default = "false"
}

variable "tags" { type = "map" 
  description = "Optional : A map of tags to assign to the resource."  
  default = { }
}
