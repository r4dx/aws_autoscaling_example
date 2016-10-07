provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "likes-service-keypair" {
  key_name = "likes-service-keypair"
  public_key = "${file("ssh/likesService.pub")}"
}

resource "aws_autoscaling_policy" "likesServiceASGPolicy" {
    name = "likesServiceASGPolicy"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.likesServiceASG.name}"
}

resource "aws_cloudwatch_metric_alarm" "likesServiceCPUAlarm" {
    alarm_name = "likesServiceCPUAlarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "50"
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.likesServiceASG.name}"
    }
    alarm_description = "Monitors CPU utilization and triggers policy to adjust autoscaling group size"
    alarm_actions = ["${aws_autoscaling_policy.likesServiceASGPolicy.arn}"]
}

resource "aws_elb" "likes-service-elb" {
  name = "likes-service-elb"

  availability_zones = ["${split(",", var.availability_zones)}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    timeout = 30
    target = "HTTP:8080/v1/healthcheck"
    interval = 300
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


resource "aws_launch_configuration" "likes-service-lc" {
  depends_on = ["aws_s3_bucket_object.rpm"]

  name = "likes-service-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  user_data = <<EOF
#!/bin/bash
sudo su
yum install -y redhat-lsb-core
yum remove -y java-1.7.0-openjdk
yum install -y java-1.8.0-openjdk
wget ${aws_s3_bucket.rpm_bucket.website_endpoint}/${aws_s3_bucket_object.rpm.key}
yum install -y ${aws_s3_bucket_object.rpm.key}
service likesService start
EOF

  iam_instance_profile = "${aws_iam_instance_profile.likesService_iam_profile.name}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.likes-service-keypair.key_name}"
}

output "elb" {
  value = "${aws_elb.likes-service-elb.dns_name}"
}