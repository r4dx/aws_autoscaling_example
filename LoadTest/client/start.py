import boto3
import sys
import os
import subprocess

ASG_NAME = "load-server-asg"
JMETER_PATH = "apache-jmeter-3.0/bin/jmeter.bat"
JMETER_SCRIPT = "script.jmx"

class Instance:
	def __init__(self, botoClient, instanceId):
		self.botoClient = botoClient
		self.instanceId = instanceId

	def getPublicDNS(self):
		response = self.botoClient.describe_instances(InstanceIds=[self.instanceId])
		reservations = response['Reservations']
		if len(reservations) != 1:
			raise Exception("Can't find reservations in instance: " + self.instanceId)

		instances = reservations[0]['Instances']
		if len(instances) != 1:  
			raise Exception("Can't find instance " + self.instanceId)

		return instances[0]['PublicDnsName']

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

autoscalingGroup = AutoscalingGroup(boto3.client('autoscaling'), boto3.client('ec2'), ASG_NAME)
instances = autoscalingGroup.getInstances()
command = [os.path.join(sys.path[0], JMETER_PATH), "-n", "-t " + JMETER_SCRIPT]
command.append("-R ");
for instance in instances:
	command[-1] += instance.getPublicDNS() + " "

subprocess.call(command)