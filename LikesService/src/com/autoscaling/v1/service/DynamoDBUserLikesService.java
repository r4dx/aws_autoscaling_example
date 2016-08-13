package com.autoscaling.v1.service;

import com.amazonaws.services.dynamodbv2.document.*;
import com.amazonaws.services.dynamodbv2.document.spec.GetItemSpec;
import com.amazonaws.services.dynamodbv2.document.spec.UpdateItemSpec;
import com.autoscaling.v1.dao.UserLikes;

public class DynamoDBUserLikesService implements UserLikesService {
    private Table table;

    public DynamoDBUserLikesService(DynamoDB dynamoDB) {
        table = dynamoDB.getTable(UserLikes.tableName);
    }

    @Override
    public void like(String userId) {
        AttributeUpdate update = new AttributeUpdate(UserLikes.likesAttributeName).addNumeric(1);
        UpdateItemSpec updateItemSpec = new UpdateItemSpec()
                .withPrimaryKey(UserLikes.userIdAttributeName, userId)
                .withAttributeUpdate(update);
        table.updateItem(updateItemSpec);
    }

    @Override
    public long getLikes(String userId) {
        GetItemSpec getItemSpec = new GetItemSpec()
                .withPrimaryKey(UserLikes.userIdAttributeName, userId);
        Item item = table.getItem(getItemSpec);
        return (long)item.get(UserLikes.likesAttributeName);
    }
}
