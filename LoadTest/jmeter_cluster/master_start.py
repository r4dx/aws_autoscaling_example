import boto3
import sys
import os
import subprocess

ASG_NAME = "jmeter-slave-ASG"
ELB_TO_LOADTEST_NAME = "likes-service-elb"

JMETER_PATH = "apache-jmeter-3.0/bin/jmeter"
JMETER_SCRIPT = "script.jmx"
class Instance:
	def __init__(self, botoClient, instanceId):
		self.botoClient = botoClient
		self.instanceId = instanceId

	def getPublicIP(self):
		response = self.botoClient.describe_instances(InstanceIds=[self.instanceId])
		reservations = response['Reservations']
		if len(reservations) != 1:
			raise Exception("Can't find reservations in instance: " + self.instanceId)

		instances = reservations[0]['Instances']
		if len(instances) != 1:  
			raise Exception("Can't find instance " + self.instanceId)

		return instances[0]['PublicIpAddress']

class AutoscalingGroup:
	def __init__(self, autoscalingBotoClient, ec2BotoClient, name):
		self.name = name
		self.botoClient = autoscalingBotoClient
		self.ec2Client = ec2BotoClient

	def getInstances(self):
		response = self.botoClient.describe_auto_scaling_groups(AutoScalingGroupNames=[self.name], MaxRecords=1)
		asgs = response['AutoScalingGroups']

		if len(asgs) != 1:
			raise Exception("Can't find autoscaling group: " + self.name)

		asg = asgs[0];
		instances = []

		for instance in asg['Instances']:
			instances.append(Instance(self.ec2Client, instance['InstanceId']))

		return instances

class ElasticLoadBalancer:
	def __init__(self, elbBotoClient, name):
		self.name = name
		self.botoClient = elbBotoClient

	def getDNSName(self):
		response = self.botoClient.describe_load_balancers(LoadBalancerNames=[self.name])
		elbs = response['LoadBalancerDescriptions']
		if (len(elbs) != 1):
			raise Exception("Can't find or too many elbs with the name " + self.name)

		return elbs[0]['DNSName']

autoscalingGroup = AutoscalingGroup(boto3.client('autoscaling', region_name = sys.argv[1]), boto3.client('ec2', region_name = sys.argv[1]), ASG_NAME)
instances = autoscalingGroup.getInstances()
elb = ElasticLoadBalancer(boto3.client('elb', region_name = sys.argv[1]), ELB_TO_LOADTEST_NAME)
absoluteJmeterPath = os.path.join(sys.path[0], JMETER_PATH)

command = [absoluteJmeterPath, '-n', '-t', JMETER_SCRIPT, '-R ']
command[-1] += ','.join([instance.getPublicIP() for instance in instances])
subprocess.call(command)