package com.safeone.dashboard.domain.sensor;

import com.safeone.dashboard.domain.sensor.dto.UpdatePosition;
import com.safeone.dashboard.domain.sensor.service.NewSensorService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/sensors")
@RequiredArgsConstructor
public class NewSensorController {

    private final NewSensorService newSensorService;

    @PutMapping("/update-position")
    public int updatePosition(@RequestBody UpdatePosition updatePosition) {
        return newSensorService.updatePosition(updatePosition);
    }

}
