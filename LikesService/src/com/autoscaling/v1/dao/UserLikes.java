package com.autoscaling.v1.dao;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;

@DynamoDBTable(tableName = UserLikes.tableName)
public class UserLikes {
    public static final String tableName = "UserLikes";
    public static final String userIdAttributeName = "userId";
    public static final String likesAttributeName = "likes";

    private String userId;
    private long likes;

    @DynamoDBAttribute(attributeName = userIdAttributeName)
    @DynamoDBHashKey
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }

    @DynamoDBAttribute(attributeName = likesAttributeName)
    public long getLikes() {
        return likes;
    }
    public void setLikes(long likes) {
        this.likes = likes;
    }
}
