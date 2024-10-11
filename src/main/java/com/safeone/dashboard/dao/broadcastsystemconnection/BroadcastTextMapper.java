package com.safeone.dashboard.dao.broadcastsystemconnection;

import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastTextDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface BroadcastTextMapper {
    int selectBroadcastTextListTotal(Map param);

    List<BroadcastTextDto> selectBroadcastTextList(Map param);

    int insertBroadcastText(Map param);

    int updateBroadcastText(Map param);

    int deleteBroadcastText(Map param);
}
    