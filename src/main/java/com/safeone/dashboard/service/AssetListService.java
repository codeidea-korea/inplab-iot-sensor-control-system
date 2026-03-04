package com.safeone.dashboard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.safeone.dashboard.dto.EquipmentDto;
import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AssetListMapper;
import com.safeone.dashboard.dto.AssetListDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssetListService {
    private final AssetListMapper mapper;

	public List<EquipmentDto> getEquipmentList(Map param) {
		return mapper.selectEquipmentList(param);
	}

}
