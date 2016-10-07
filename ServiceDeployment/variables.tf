variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-6869aa05"
    "us-west-2" = "ami-7172b611"
  }
}

variable "availability_zones" {
  default = "us-east-1b,us-east-1a"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default = "2"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default = "3"
}

variable "path_to_rpm" {
  description = "Path to RPM file to upload to S3, - will be used install on hosts after launch!"
  default = "../LikesService/build/distributions/likesService-1.0.0-1.noarch.rpm"
}