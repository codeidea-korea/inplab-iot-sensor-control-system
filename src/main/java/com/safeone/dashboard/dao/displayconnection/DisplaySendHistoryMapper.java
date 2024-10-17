package com.safeone.dashboard.dao.displayconnection;

import com.safeone.dashboard.dto.displayconnection.DisplaySendHistoryDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DisplaySendHistoryMapper {
    List<DisplaySendHistoryDto> getList(Map param);
    int getTotalCount(Map param);
}
