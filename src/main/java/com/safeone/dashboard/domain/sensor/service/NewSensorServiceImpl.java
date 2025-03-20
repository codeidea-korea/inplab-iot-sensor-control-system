package com.safeone.dashboard.domain.sensor.service;

import com.safeone.dashboard.domain.sensor.dto.UpdateCctvPosition;
import com.safeone.dashboard.domain.sensor.dto.UpdatePosition;
import com.safeone.dashboard.domain.sensor.repository.NewSensorMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class NewSensorServiceImpl implements NewSensorService {

    private final NewSensorMapper newSensorMapper;

    @Override
    public int updatePosition(UpdatePosition updatePosition) {
        return newSensorMapper.updatePosition(updatePosition);
    }

    @Override
    public int updateCctvPosition(UpdateCctvPosition updatePosition) {
        return newSensorMapper.updateCctvPosition(updatePosition);
    }

}
