package com.autoscaling.v1;

import com.autoscaling.v1.responses.HealthcheckResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

@RestController
public class LikesController {
    private static final Logger logger = LoggerFactory.getLogger(LikesController.class);

    @RequestMapping(value = "/v1/{userId}/likes", method = RequestMethod.POST)
    public void addLike(@PathVariable String userId) {

    }

    @RequestMapping(value = "/v1/{userId}/likes", method = RequestMethod.GET)
    public long getLikes(@PathVariable String userId) {
        return -1;
    }

    @RequestMapping(value = "/v1/healthcheck", method = RequestMethod.GET)
    public HealthcheckResult getHealthcheck() {
        return new HealthcheckResult(true);
    }
}
