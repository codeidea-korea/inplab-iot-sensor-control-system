package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;

import java.util.List;

public interface CctvService {

  ObjectNode getCctv(GetAdminAddCctvDto getAdminAddCctvDto);

  ObjectNode insCctv(List<InsAdminAddCctvDto> insAdminAddCctvDtoList);

  ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDto);

  ObjectNode delCctv(List<DelAdminAddCctvDto> delAdminAddCctvDtoList);

  ObjectNode getDistrict(GetAdminAddDistrictDto getAdminAddDistrictDto);

  ObjectNode getMaintComp(GetAdminAddMaintCompDto getAdminAddDistrictDto);
}
