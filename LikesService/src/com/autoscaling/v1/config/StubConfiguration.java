package com.autoscaling.v1.config;

import org.springframework.stereotype.Service;

// TODO: Replace with centralized configuration (e.g. consul, zookeeper, just S3 file)
@Service
public class StubConfiguration implements Configuration {
    @Override
    public long getLikesTableReadCapacityUnits() {
        return 5;
    }

    @Override
    public long getLikesTableWriteCapacityUnits() {
        return 5;
    }
}
