package com.safeone.dashboard.domain.district;

import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import com.safeone.dashboard.domain.district.service.DistrictService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/districts")
@RequiredArgsConstructor
public class DistrictController {

    private final DistrictService districtService;

    @PutMapping("/update-position")
    public int updatePosition(@RequestBody UpdatePosition updatePosition) {
        return districtService.updatePosition(updatePosition);
    }

}
