import boto3

ASG_NAME = "load-server-asg"

client = boto3.client('autoscaling')
response = client.describe_auto_scaling_groups(AutoScalingGroupNames=[ASG_NAME], MaxRecords=1)

asgs = response['AutoScalingGroups'];

if len(asgs) != 1:
	print "Can't find autoscaling group: " + ASG_NAME

asg = asgs;

print "success"