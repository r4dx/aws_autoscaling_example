package com.autoscaling.v1.service;

import org.springframework.stereotype.Service;

// TODO: Replace with real health check (e.g. DynamoDB connectivity check)
@Service
public class StubHealthcheckService implements HealthcheckService {
    @Override
    public boolean isHealthy() {
        return true;
    }
}
