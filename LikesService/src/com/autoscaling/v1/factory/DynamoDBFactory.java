package com.autoscaling.v1.factory;

import com.amazonaws.auth.InstanceProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.util.TableUtils;
import com.autoscaling.v1.dao.UserLikes;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
public class DynamoDBFactory {

    @Bean
    @Scope("singleton")
    public AmazonDynamoDBClient amazonDynamoDBClient() {
        AmazonDynamoDBClient client = new AmazonDynamoDBClient(new InstanceProfileCredentialsProvider());
        client.setRegion(Region.getRegion(Regions.US_EAST_1));
        return client;
    }

    @Bean
    @Scope("singleton")
    public DynamoDB dynamoDB(AmazonDynamoDB client,
                             com.autoscaling.v1.config.Configuration configuration) {
        initializeTables(configuration, client);
        return new DynamoDB(client);
    }

    private void initializeTables(com.autoscaling.v1.config.Configuration configuration,
                                  AmazonDynamoDB dynamoDB) {
        DynamoDBMapper mapper = new DynamoDBMapper(dynamoDB);
        CreateTableRequest request = mapper.generateCreateTableRequest(UserLikes.class);
        request.setProvisionedThroughput(new ProvisionedThroughput(configuration.getLikesTableReadCapacityUnits(),
                configuration.getLikesTableWriteCapacityUnits()));
        TableUtils.createTableIfNotExists(dynamoDB, request);
    }
}
