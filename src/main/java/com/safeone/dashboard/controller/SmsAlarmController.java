package com.safeone.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SmsAlarmListDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SmsAlarmService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/smsAlarm")
public class SmsAlarmController extends JqGridAbstract<SmsAlarmListDto> {
    @Autowired
    private SmsAlarmService smsAlarmService;
	
    @Autowired
    private CommonCodeService commonCodeService;
    
    protected SmsAlarmController() {
        super(SmsAlarmListDto.class);
    }
    
	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		Map<String, FieldDetails> result = super.getColumnDataJson();
        result.get("threshold").type = this.getCommonCodeListStr("임계치알람");
        result.get("auto_send_flag").type = ":;ON:ON;OFF:OFF";
		return result;
	}

    private String getCommonCodeListStr(String cat){
        String result = ":";
        Map<String,Object> pm = new HashMap<String,Object>();
        pm.put("category", cat);

        List<Map> rList = commonCodeService.getCommonCodeList(pm);
        for(Map m : rList) {
            result += ";"+ m.get("code") +":"+ m.get("name");
        }

        return result;
    }


    @Override
    protected List getList(Map param) {
        return smsAlarmService.getList(param);
    }
    
    @Override
    protected int getTotalCount(Map param) {
        return smsAlarmService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "smsAlarm";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return smsAlarmService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {    	
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return smsAlarmService.create(param);
    }
    
    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return smsAlarmService.update(param);
    }


}
