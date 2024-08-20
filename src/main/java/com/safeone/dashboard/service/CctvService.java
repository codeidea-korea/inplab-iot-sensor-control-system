package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddCctvDto;
import com.safeone.dashboard.dto.GetAdminAddCctvDto;
import com.safeone.dashboard.dto.InsAdminAddCctvDto;
import com.safeone.dashboard.dto.UdtAdminAddCctvDto;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface CctvService {

    ObjectNode getCctv(GetAdminAddCctvDto getAdminAddCctvDto);

    ObjectNode insCctv(InsAdminAddCctvDto insAdminAddCctvDto);

    ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDto);

    ObjectNode delCctv(DelAdminAddCctvDto delAdminAddCctvDto);

}
