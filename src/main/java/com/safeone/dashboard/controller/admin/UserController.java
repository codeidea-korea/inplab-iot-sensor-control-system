package com.safeone.dashboard.controller.admin;

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
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.UserService;
import com.safeone.dashboard.util.CommonUtils;

@Controller
@RequestMapping("/admin/user")
public class UserController extends JqGridAbstract<UserDto> {
    @Autowired
    private UserService userService;

	@Autowired
	private CommonCodeService commonCodeService;
    
    protected UserController() {
        super(UserDto.class);
    }
    
//	@Override
//	public Map<String, FieldDetails> getColumnDataJson() {
//		Map<String, FieldDetails> result = super.getColumnDataJson();
//		((FieldDetails)result.get("grade")).type = this.getCommonCodeListStr("사용자구분");
//
//		return result;
//	}
//
//	private String getCommonCodeListStr(String cat){
//		String result = ":";
//		Map<String,Object> pm = new HashMap<String,Object>();
//		pm.put("category", cat);
//
//		List<Map> rList = commonCodeService.getCommonCodeList(pm);
//		for(Map m : rList) {
//			result += ";"+String.valueOf(m.get("code"))+":"+String.valueOf(m.get("name"));
//		}
//
//		return result;
//	}

    @Override
    protected List getList(Map param) {
    	if(param.containsKey("reg_date")) {
        	String[] dates = ((String)param.get("reg_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("reg_date_start", dates[0]);
        		param.put("reg_date_end", dates[1]);
        	}else {
        		param.put("reg_date_start", dates[0]);
        		param.put("reg_date_end", dates[0]);
        	}
    	}
    	
    	if(param.containsKey("mod_date")) {
        	String[] dates = ((String)param.get("mod_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[1]);
        	}else {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[0]);
        	}
    	}
        return userService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
    	if(param.containsKey("reg_date")) {
        	String[] dates = ((String)param.get("reg_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("reg_date_start", dates[0]);
        		param.put("reg_date_end", dates[1]);
        	}else {
        		param.put("reg_date_start", dates[0]);
        		param.put("reg_date_end", dates[0]);
        	}
    	}
    	
    	if(param.containsKey("mod_date")) {
        	String[] dates = ((String)param.get("mod_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[1]);
        	}else {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[0]);
        	}
    	}
        return userService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/user";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return userService.delete(param);
    }

    @ResponseBody
    @GetMapping("/isExists")
    public int isExists(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return userService.isExists(param);
    }
    
    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	
    	param.put("password", CommonUtils.encrypt(param.get("password").toString()));
    	
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return userService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {

		if (!param.get("password").equals("")) param.put("password", CommonUtils.encrypt(param.get("password").toString()));
    	
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return userService.update(param);
    }
}
