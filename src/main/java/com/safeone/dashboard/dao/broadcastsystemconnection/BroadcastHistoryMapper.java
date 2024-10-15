package com.safeone.dashboard.dao.broadcastsystemconnection;

import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastHistoryDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface BroadcastHistoryMapper {
    int selectBroadcastHistoryListTotal(Map param);

    List<BroadcastHistoryDto> selectBroadcastHistoryList(Map param);

    int insertBroadcastHistory(Map param);

    int updateBroadcastHistory(Map param);

    int deleteBroadcastHistory(Map param);
}
    