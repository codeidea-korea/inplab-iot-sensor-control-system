package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.ChannelMapper;
import com.safeone.dashboard.dto.ChannelDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChannelService implements JqGridService<ChannelDto> {

    private final ChannelMapper mapper;

    @Override
    public List<ChannelDto> getList(Map param) {
        return mapper.selectChannelList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectChannelListTotal(param);
    }

    @Override
    public boolean create(Map param) {
    	// TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public ChannelDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateChannel(param) > 0;
    }

    @Override
    public int delete(Map param) {
    	// TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }
}
