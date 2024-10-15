package com.safeone.dashboard.service.broadcastsystemconnection;

import com.safeone.dashboard.dao.broadcastsystemconnection.BroadcastTextMapper;
import com.safeone.dashboard.dao.operationconfigurationsetting.UserManagementMapper;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastTextDto;
import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class BroadcastTextService implements JqGridService<BroadcastTextDto> {

    private final BroadcastTextMapper mapper;

    @Override
    public List<BroadcastTextDto> getList(Map param) {
        return mapper.selectBroadcastTextList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectBroadcastTextListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertBroadcastText(param) > 0;
    }

    @Override
    public BroadcastTextDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return mapper.updateBroadcastText(param) > 0;
    }

    @Override
    public int delete(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return mapper.deleteBroadcastText(param);
    }
}
