package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.ChannelDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ChannelMapper {
    int selectChannelListTotal(Map param);
    List<ChannelDto> selectChannelList(Map param);
    int updateChannel(Map param);
}
    