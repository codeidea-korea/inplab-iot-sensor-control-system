package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.displayconnection.DisplayBoardDto;

import java.util.List;
import java.util.Map;

public interface DisplayBoardService {

  ObjectNode getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto);

  ObjectNode insDisplayBoard(List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList);

  ObjectNode udtDisplayBoard(List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList);

  ObjectNode delDisplayBoard(List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList);

  List<DisplayBoardDto> all(Map<String, Object> param);

  int sendHistory(Map<String, Object> param);

  String getMaxDispbdNo();
}