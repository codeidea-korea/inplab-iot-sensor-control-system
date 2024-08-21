package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddCctvDto;
import com.safeone.dashboard.dto.GetAdminAddCctvDto;
import com.safeone.dashboard.dto.InsAdminAddCctvDto;
import com.safeone.dashboard.dto.UdtAdminAddCctvDto;
import java.util.List;

public interface CctvService {

  ObjectNode getCctv(GetAdminAddCctvDto getAdminAddCctvDto);

  ObjectNode insCctv(List<InsAdminAddCctvDto> insAdminAddCctvDtoList);

  ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDto);

  ObjectNode delCctv(List<DelAdminAddCctvDto> delAdminAddCctvDtoList);

}
