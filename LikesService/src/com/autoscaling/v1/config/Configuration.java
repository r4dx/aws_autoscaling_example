package com.autoscaling.v1.config;


public interface Configuration {
    long getLikesTableReadCapacityUnits();
    long getLikesTableWriteCapacityUnits();
}
