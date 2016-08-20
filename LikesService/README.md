# API

1. POST /v1/<userId>/likes, - adds like to a user
2. GET /v1/<userId>/likes, - gets amount of likes for a user
3. GET /v1/healthcheck, - returns { "healthy": true } if healthy

# Principles

1. REST over HTTP as a protocol
2. Spring boot as a framework
3. DynamoDB to store data, - N.B. There is the whole science behind creating really distributed counters but it's not very important for our example, - let's assume that scaling counters per user is enough, - see links for details!

# Next steps

1. Centralized configuration (e.g. consul)
2. Centralized logging (e.g. elastic search)
3. Really sharded counters