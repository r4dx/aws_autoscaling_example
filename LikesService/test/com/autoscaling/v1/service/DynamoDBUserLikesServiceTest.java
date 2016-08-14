package com.autoscaling.v1.service;

import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.local.embedded.DynamoDBEmbedded;
import com.autoscaling.v1.config.StubConfiguration;
import com.autoscaling.v1.factory.DynamoDBFactory;
import org.junit.Assert;
import org.junit.Test;

public class DynamoDBUserLikesServiceTest {

    private static final String userId = "test";

    private DynamoDB dynamoDB = new DynamoDBFactory().dynamoDB(DynamoDBEmbedded.create(), new StubConfiguration());
    private UserLikesService service = new DynamoDBUserLikesService(dynamoDB);

    @Test
    public void likeTest() {
        service.like(userId);
        Assert.assertEquals(1, service.getLikes(userId));
    }
}
