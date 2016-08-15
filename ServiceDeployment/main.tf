provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_elb" "likes-service-elb" {
  name = "likes-service-elb"

  availability_zones = ["${split(",", var.availability_zones)}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/v1/healthcheck"
    interval = 30
  }

}

resource "aws_autoscaling_group" "likesServiceASG" {
  availability_zones = ["${split(",", var.availability_zones)}"]

  name = "likes-service-asg"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.likes-service-lc.name}"
  load_balancers = ["${aws_elb.likes-service-elb.name}"]

  tag {
    key = "Name"
    value = "likes-service-asg"
    propagate_at_launch = "true"
  }
}

resource "aws_key_pair" "likes-service-keypair" {
  key_name = "likes-service-keypair"
  public_key = "${file("ssh/likesService.pub")}"
}

resource "aws_launch_configuration" "likes-service-lc" {
  name = "likes-service-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"

  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.likes-service-keypair.key_name}"
}


resource "aws_security_group" "default" {
  name = "likes-service-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}