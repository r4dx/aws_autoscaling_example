package com.autoscaling.v1.controller;

import com.autoscaling.v1.controller.responses.HealthcheckResult;
import com.autoscaling.v1.service.HealthcheckService;
import com.autoscaling.v1.service.UserLikesService;
import org.junit.Assert;
import org.junit.Test;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class LikesControllerTest {
    final String testUserId = "test";

    private UserLikesService likesService = mock(UserLikesService.class);
    private HealthcheckService healthcheckService = mock(HealthcheckService.class);

    private LikesController controller = new LikesController(likesService, healthcheckService);

    @Test
    public void testAddLike() {
        controller.addLike(testUserId);
        verify(likesService).like(testUserId);
    }

    @Test
    public void testGetLikes() {
        long result = controller.getLikes(testUserId);
        long expected = verify(likesService).getLikes(testUserId);
        Assert.assertEquals(expected, result);
    }

    @Test
    public void testGetHealthCheck() {
        HealthcheckResult result = controller.getHealthcheck();
        boolean expected = verify(healthcheckService).isHealthy();
        Assert.assertEquals(result.getHealthy(), expected);
    }
}
