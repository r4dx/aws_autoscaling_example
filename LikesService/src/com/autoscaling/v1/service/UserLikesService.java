package com.autoscaling.v1.service;

public interface UserLikesService {
    void like(String userId);
    long getLikes(String userId);
}
