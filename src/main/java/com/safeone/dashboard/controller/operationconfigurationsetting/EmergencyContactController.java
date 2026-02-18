package com.safeone.dashboard.controller.operationconfigurationsetting;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.operationconfigurationsetting.EmergencyContactDto;
import com.safeone.dashboard.service.operationconfigurationsetting.EmergencyContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/operation-configuration-setting/emergency-contact")
public class EmergencyContactController extends JqGridAbstract<EmergencyContactDto> {
    @Autowired
    private EmergencyContactService emergencyContactService;

    protected EmergencyContactController() {
        super(EmergencyContactDto.class);
    }

    @Override
    protected List<EmergencyContactDto> getList(Map param) {
        setParam(param);
        return emergencyContactService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return emergencyContactService.getTotalCount(param);
    }

    private void setParam(Map param) {
    }

    @Override
    protected String setViewPage() {
        return "operation-configuration-setting/emergency-contact";
    }

    @ResponseBody
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return emergencyContactService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public ResponseEntity<?> insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {
            return ResponseEntity.ok(emergencyContactService.create(param));
        } catch (DuplicateKeyException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "동일한 현장/연락처1(휴대폰)이 이미 존재합니다."));
        }
    }

    @ResponseBody
    @PostMapping("/mod")
    public ResponseEntity<?> update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {
            return ResponseEntity.ok(emergencyContactService.update(param));
        } catch (DuplicateKeyException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "동일한 현장/연락처1(휴대폰)이 이미 존재합니다."));
        }
    }

}
