package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;

public interface BroadcastService {

  ObjectNode getBroadcast(GetAdminAddBroadcastDto getAdminAddBroadcastDto);

  ObjectNode insBroadcast(List<InsAdminAddBroadcastDto> insAdminAddBroadcastDtoList);

  ObjectNode udtBroadcast(List<UdtAdminAddBroadcastDto> udtAdminAddBroadcastDtoList);

  ObjectNode delBroadcast(List<DelAdminAddBroadcastDto> delAdminAddBroadcastDtoList);

}