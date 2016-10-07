# Abstract
This is an example of how autoscaling can be built in AWS cloud and additionally how load testing can be performed in the same stack of technologies.

# Method
Here are most important parts of what's done:

1. Service to load test, - stores Likes count users set to each other. See LikesService for details.
2. Service deployment code, - scripts to create autoscaling infrastructure for service from scratch. See ServiceDeployment for details.
3. Load testing client, - scripts to create a load on the service in question. See LoadClient for details.
4. Load testing runner, - scripts to create load clients infrastructure, gather results from each client. See LoadClientRunner for details.

# Prerequisites

1. Gradle 2.4
2. HashiCorp Terraform
3. AWS account
4. Python 2.7
5. https://github.com/boto/boto3

# LikesService

API:

1. POST /v1/<userId>/likes, - adds like to a user
2. GET /v1/<userId>/likes, - gets amount of likes for a user
3. GET /v1/healthcheck, - returns { "healthy": true } if healthy

Principles:

1. REST over HTTP as a protocol
2. Spring boot as a framework
3. DynamoDB to store data, - N.B. There is the whole science behind creating really distributed counters but it's not very important for our example, - let's assume that scaling counters per user is enough, - see links for details!
4. Gradle as a build system
5. Packaged in RPM


# ServiceDeployment

1. Creates S3 bucket and uploads RPM into it
2. Creates launch configuration with user_data which downloads and setups service RPM
3. Creates security group, assignes IAM policy to instances, manages tagging
4. Creates AWS autoscaling group and autoscaling policies
5. Here's how the end graph looks:
![Alt text](docs/aws_graph.png)

# LoadClient, - TBD

1. jMeter as a core component
2. Measures success rate per API, average, min, max response time

# LoadClientRunner, - TBD

N.B. It's required to configure AWS credentials before running configure.py. 

```aws configure``` 

1. Creates AWS ec2 instances, manages tagging
2. Propagates load testing configuration to instances and runs them
3. Tracks status if load testing complete
4. Gathers results from each client and returns aggregated table

# Links

1. http://highscalability.com/blog/2014/3/12/paper-scalable-eventually-consistent-counters-over-unreliabl.html
2. https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html
3. http://jmeter.apache.org/usermanual/remote-test.html