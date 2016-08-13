# Abstract
This is an example of how autoscaling can be built in AWS cloud and additionally how load testing can be performed in the same stack of technologies.

# Method
Here are most important parts of what's done:

1. Service to load test, - stores Likes count users set to each other. See LikesService for details.
2. Service deployment code, - scripts to create autoscaling infrastructure for service from scratch. See ServiceDeployment for details.
3. Load testing client, - scripts to create a load on the service in question. See LoadClient for details.
4. Load testing runner, - scripts to create load clients infrastructure, gather results from each client. See LoadClientRunner for details.

# LikesService

POST /v1/<userId>/likes, - adds like to a user
GET /v1/<userId>/likes, - gets amount of likes for a user
GET /v1/healthcheck, - returns { "healthy": true } if healthy

1. REST over HTTP as a protocol
2. Spring boot as a framework
3. DynamoDB to store data, - N.B. There is the whole science behind creating really distributed counters but it's not very important for our example, - let's assume that scaling counters per user is enough, - see links for details!

# ServiceDeployment

1. Ansible to do Infrastructure as a Code
2. Creates AWS beanstalk configuration, autoscaling group, manages tagging

# LoadClient

1. jMeter as a core component
2. Measures success rate per API, average, min, max response time

# LoadClientRunner

1. Ansible to do Infrastructure as a Code
2. Creates AWS ec2 instances, manages tagging
3. Gathers results from each client and returns aggregated table

# Links

1. http://highscalability.com/blog/2014/3/12/paper-scalable-eventually-consistent-counters-over-unreliabl.html