package com.safeone.dashboard.controller.operationconfigurationsetting;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import com.safeone.dashboard.service.operationconfigurationsetting.UserManagementService;
import com.safeone.dashboard.util.CommonUtils;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/operation-configuration-setting/user-management")
public class UserManagementController extends JqGridAbstract<UserManagementDto> {
    @Autowired
    private UserManagementService userManagementService;

    protected UserManagementController() {
        super(UserManagementDto.class);
    }

    @Override
    protected List<UserManagementDto> getList(Map param) {
        setParam(param);
        return userManagementService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return userManagementService.getTotalCount(param);
    }

    private void setParam(Map param) {
    }

    @Override
    protected String setViewPage() {
        return "operation-configuration-setting/user-management";
    }

    @Override
    public List<Map<Object, Object>> getDownloadExcelDataList(Map<String, FieldDetails> result, List<Map<Object, Object>> list) {
        List<Map<Object, Object>> excelList = super.getDownloadExcelDataList(result, list);

        for (Map<Object, Object> row : excelList) {
            Object usrPh = row.get("usr_ph");
            if (usrPh != null) {
                row.put("usr_ph", formatPhoneNumber(usrPh.toString()));
            }

            Object usrFlag = row.get("usr_flag");
            if (usrFlag != null) {
                row.put("usr_flag", formatUserFlag(usrFlag.toString()));
            }
        }

        return excelList;
    }

    @ResponseBody
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return userManagementService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("usr_pwd", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        param.put("usr_pwd_confm", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        return userManagementService.create(param);
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        if (param.get("usr_pwd") != null && !param.get("usr_pwd").toString().isEmpty()) {
            param.put("usr_pwd", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        }
        return userManagementService.update(param);
    }

    @ResponseBody
    @PostMapping("/check-id")
    public boolean checkId(HttpServletRequest request, @RequestParam Map<String, Object> param){
        String usrId = param.get("usr_id").toString();
        int count = userManagementService.checkDuplicatedId(usrId);
        return count == 0;
    }

    private String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            return "";
        }

        String cleanNum = phoneNumber.replaceAll("[^0-9]", "");

        if (cleanNum.length() == 11) {
            return cleanNum.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        }

        if (cleanNum.length() == 10) {
            if (cleanNum.startsWith("02")) {
                return cleanNum.replaceFirst("(\\d{2})(\\d{4})(\\d{4})", "$1-$2-$3");
            }
            return cleanNum.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
        }

        if (cleanNum.length() == 9 && cleanNum.startsWith("02")) {
            return cleanNum.replaceFirst("(\\d{2})(\\d{3})(\\d{4})", "$1-$2-$3");
        }

        if (cleanNum.length() == 8) {
            return cleanNum.replaceFirst("(\\d{4})(\\d{4})", "$1-$2");
        }

        return cleanNum;
    }

    private String formatUserFlag(String usrFlag) {
        if ("1".equals(usrFlag)) {
            return "운영 관리자";
        }
        if ("0".equals(usrFlag)) {
            return "시스템 관리자";
        }
        return usrFlag;
    }
}
