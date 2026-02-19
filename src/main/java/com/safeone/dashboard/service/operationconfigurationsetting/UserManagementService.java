package com.safeone.dashboard.service.operationconfigurationsetting;

import com.safeone.dashboard.dao.operationconfigurationsetting.UserManagementMapper;
import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserManagementService implements JqGridService<UserManagementDto> {

    private final UserManagementMapper mapper;

    @Override
    public List<UserManagementDto> getList(Map param) {
        return mapper.selectUserManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectUserManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        if (mapper.selectByUserId(param) > 0) {
            throw new IllegalArgumentException("이미 등록된 사용자 ID 입니다.");
        }
        return mapper.insertUserManagement(param) > 0;
    }

    @Override
    public UserManagementDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateUserManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteUserManagement(param);
    }

    public int checkDuplicatedId(String usrId) {
        // 기존 Mapper가 Map 형식을 받도록 되어 있으므로, Map에 담아서 전달합니다.
        Map<String, Object> param = new HashMap<>();
        param.put("usr_id", usrId);

        return mapper.selectByUserId(param);
    }
}
