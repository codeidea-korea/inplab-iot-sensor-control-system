package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.AssetListDto;
import com.safeone.dashboard.dto.SendContrDto;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface SendContrMapper {

    List<SendContrDto> selectSendContrList(Map param);
    int insertSendContr(Map param);
    int updateSendContr(Map param);
    int deleteSendContr(Map param);

    int insertSendLog(Map param);

    List<AssetListDto> selectAssetList(Map param);

    HashMap selectSendLog();
}
