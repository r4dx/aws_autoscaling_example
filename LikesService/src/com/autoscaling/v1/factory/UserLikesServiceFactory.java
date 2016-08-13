package com.autoscaling.v1.factory;

import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.autoscaling.v1.service.DynamoDBUserLikesService;
import com.autoscaling.v1.service.UserLikesService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
public class UserLikesServiceFactory {
    @Bean
    @Scope("singleton")
    public UserLikesService userLikesService(DynamoDB dynamoDB) {
        return new DynamoDBUserLikesService(dynamoDB);
    }
}
