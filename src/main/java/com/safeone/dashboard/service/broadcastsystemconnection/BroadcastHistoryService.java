package com.safeone.dashboard.service.broadcastsystemconnection;

import com.safeone.dashboard.dao.broadcastsystemconnection.BroadcastHistoryMapper;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastHistoryDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class BroadcastHistoryService implements JqGridService<BroadcastHistoryDto> {

    private final BroadcastHistoryMapper mapper;

    @Override
    public List<BroadcastHistoryDto> getList(Map param) {
        return mapper.selectBroadcastHistoryList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectBroadcastHistoryListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertBroadcastHistory(param) > 0;
    }

    @Override
    public BroadcastHistoryDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateBroadcastHistory(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteBroadcastHistory(param);
    }

    public List<Map<String, String>> getDistrictOptions() {
        return mapper.selectBroadcastHistoryDistrictOptions();
    }

    public List<Map<String, String>> getBroadcastOptions() {
        return mapper.selectBroadcastHistoryBroadcastOptions();
    }
}
