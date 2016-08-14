package com.autoscaling.v1.controller;

import com.autoscaling.v1.controller.responses.HealthcheckResult;
import com.autoscaling.v1.service.HealthcheckService;
import com.autoscaling.v1.service.UserLikesService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class LikesController {
    private static final Logger logger = LoggerFactory.getLogger(LikesController.class);

    private UserLikesService service;
    private HealthcheckService healthcheckService;

    @Autowired
    public LikesController(UserLikesService service, HealthcheckService healthcheckService) {
        this.service = service;
        this.healthcheckService = healthcheckService;
    }

    @RequestMapping(value = "/v1/{userId}/likes", method = RequestMethod.POST)
    public void addLike(@PathVariable String userId) {
        logger.info("Adding like to user '{}'", userId);
        service.like(userId);
    }

    @RequestMapping(value = "/v1/{userId}/likes", method = RequestMethod.GET)
    public long getLikes(@PathVariable String userId) {
        logger.info("Getting likes for user '{}'", userId);
        return service.getLikes(userId);
    }

    @RequestMapping(value = "/v1/healthcheck", method = RequestMethod.GET)
    public HealthcheckResult getHealthcheck() {
        return new HealthcheckResult(healthcheckService.isHealthy());
    }
}
