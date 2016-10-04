resource "aws_autoscaling_group" "jmeter-slave-ASG" {
  availability_zones = ["${split(",", var.availability_zones)}"]

  name = "jmeter-slave-ASG"
  max_size = "${var.slave_asg_size}"
  min_size = "${var.slave_asg_size}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.jmeter-slave-lc.name}"

  tag {
    key = "Name"
    value = "jmeter-slave"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "jmeter-slave-lc" {
  name = "jmeter-slave-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.slave_instance_type}"
  user_data = "${file("${path.module}/slave_setup.sh")}"

  security_groups = ["${aws_security_group.jmeter-slave-sg.id}"]
  key_name = "${aws_key_pair.jmeter-slave-keypair.key_name}"
}

resource "aws_key_pair" "jmeter-slave-keypair" {
  key_name = "jmeter-slave-keypair"
  public_key = "${file("${var.slave_ssh_public_key_file}")}"
}

resource "aws_security_group" "jmeter-slave-sg" {
  name = "jmeter-slave-sg"

#  ingress {
#    from_port = 22
#    to_port = 22
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  ingress {
#    from_port = 1099
#    to_port = 1099
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  ingress {
#    from_port = 1098
#    to_port = 1098
#    protocol = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

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
