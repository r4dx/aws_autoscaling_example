provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "load-server-keypair" {
  key_name = "load-server-keypair"
  public_key = "${file("ssh/loadServer.pub")}"
}

resource "aws_autoscaling_group" "load-server-ASG" {
  availability_zones = ["${split(",", var.availability_zones)}"]

  name = "load-server-asg"
  max_size = "${var.asg_size}"
  min_size = "${var.asg_size}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.load-server-lc.name}"

  tag {
    key = "Name"
    value = "load-server-asg"
    propagate_at_launch = "true"
  }
}


resource "aws_launch_configuration" "load-server-lc" {
  name = "load-server-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  user_data = "${file("setup.sh")}"

  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.load-server-keypair.key_name}"
}