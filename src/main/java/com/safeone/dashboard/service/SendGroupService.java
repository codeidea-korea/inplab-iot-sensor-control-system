package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SendGroupMapper;
import com.safeone.dashboard.dto.SendGroupDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SendGroupService implements JqGridService<SendGroupDto> {

    private final SendGroupMapper mapper;

    @Override
    public List<SendGroupDto> getList(Map param) {
        return mapper.selectSendGroupList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSendGroupListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertSendGroup(param);
    }

    @Override
    public SendGroupDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateSendGroup(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteSendGroup(param);
    }
}
