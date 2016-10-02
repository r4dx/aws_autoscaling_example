resource "aws_instance" "jmeter-master-instance" {
  depends_on = [ "aws_autoscaling_group.jmeter-slave-ASG" ]

  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.master_instance_type}"

  security_groups = [ "${aws_security_group.jmeter-master-sg.name}" ]
  key_name = "${aws_key_pair.jmeter-master-keypair.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jmeter_master_iam_profile.name}"

  tags {
    Name = "jmeter-master"
  }

  connection {
    user = "ec2-user"
    private_key = "${file("${var.master_ssh_private_key_file}")}"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo mkdir /jmeter-master",
      "sudo chown -R ec2-user /jmeter-master",
      "sudo pip install boto3"
    ]
  }

  provisioner "file" {
    source = "${path.module}/master_start.py"
    destination = "/jmeter-master/master_start.py"
  }

  provisioner "file" {
    source = "${var.jmx_script_file}"
    destination = "/jmeter-master/script.jmx"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /jmeter-master/",
      "curl http://apache-mirror.rbc.ru/pub/apache/jmeter/binaries/apache-jmeter-3.0.tgz > jMeter.tgz",
      "tar zxvf jMeter.tgz",
      "python master_start.py ${var.aws_region} > output"
    ]
  }
}

resource "aws_key_pair" "jmeter-master-keypair" {
  key_name = "jmeter-master-keypair"
  public_key = "${file("${var.master_ssh_public_key_file}")}"
}

resource "aws_security_group" "jmeter-master-sg" {
  name = "jmeter-master-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1099
    to_port = 1099
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

resource "aws_iam_instance_profile" "jmeter_master_iam_profile" {
    name = "jmeter_master_iam_profile"
    roles = ["${aws_iam_role.jmeter_master_iam_role.name}"]
}

resource "aws_iam_role" "jmeter_master_iam_role" {
    name = "jmeter_master_iam_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "jmeter_master_iam_role_attachment" {
    role = "${aws_iam_role.jmeter_master_iam_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}