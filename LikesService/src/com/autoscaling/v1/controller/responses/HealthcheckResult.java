package com.autoscaling.v1.controller.responses;

public class HealthcheckResult {
    private boolean healthy;

    public HealthcheckResult(boolean healthy) {
        this.healthy = healthy;
    }

    public boolean getHealthy() {
        return healthy;
    }
}
