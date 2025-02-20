package com.safeone.dashboard.domain.district;

import com.safeone.dashboard.domain.district.dto.District;
import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import com.safeone.dashboard.domain.district.service.DistrictService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/districts")
@RequiredArgsConstructor
public class DistrictController {

    private final DistrictService districtService;

    @PutMapping("/update-position")
    public int updatePosition(@RequestBody UpdatePosition updatePosition) {
        return districtService.updatePosition(updatePosition);
    }

    @GetMapping("/all")
    public List<District> getAll() {
        return districtService.getAll();
    }

}
