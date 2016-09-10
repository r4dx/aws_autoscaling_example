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

variable "asg_size" {
  description = "The size of load testing servers ASG"
  default = "2"
}