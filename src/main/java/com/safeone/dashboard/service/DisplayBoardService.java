package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;

import java.util.List;

public interface DisplayBoardService {

  ObjectNode getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto);

  ObjectNode insDisplayBoard(List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList);

  ObjectNode udtDisplayBoard(List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList);

  ObjectNode delDisplayBoard(List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList);

}