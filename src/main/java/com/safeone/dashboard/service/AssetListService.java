package com.safeone.dashboard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AssetListMapper;
import com.safeone.dashboard.dto.AssetListDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssetListService implements JqGridService<AssetListDto> {
    private final AssetListMapper mapper;

    @Override
    public List<AssetListDto> getList(Map param) {
    	return mapper.selectAssetList(param);
    }

    public Map selectAssetInfo(String assetId) {
    	return mapper.selectAssetInfo(assetId);
    }

    @Override
    public int getTotalCount(Map param) {
    	return mapper.selectAssetListTotal(param);
    }
    
    @Override
    public boolean create(Map param) {
    	
    	int id = mapper.insertAsset(param);
    	
    	Map chParam = new HashMap<>();
    	chParam.putAll(param);
    	chParam.put("asset_id", id);
    	
    	if("2".equals(String.valueOf(param.get("asset_kind_id_hid")))) {//2:구조물경사계
    		
    		//채널
    		String name = String.valueOf(chParam.get("name"));
    		
    		chParam.put("name", name+"-X");
			chParam.put("seq", "0");
			chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_1")));
			mapper.insertChannel(chParam);
			
			//계산수식, 관리기준값
			mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
			//채널
			chParam.put("name", name+"-Y");
			chParam.put("seq", "1");
			chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_2")));
			mapper.insertChannel(chParam);
			
			//계산수식, 관리기준값
			mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
    	}else if("3".equals(String.valueOf(param.get("asset_kind_id_hid")))
    			|| "4".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
    			|| "6".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
    			|| "7".equals(String.valueOf(param.get("asset_kind_id_hid"))) ){//3:지표변위계, 4:강우량계, 6:지하수위계(6), 7:지하수위계(7)
    		
    		//채널
    		chParam.put("seq", "0");
    		chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_1")));
    		mapper.insertChannel(chParam);
    		
    		//계산수식, 관리기준값
    		mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
    	}
    	//else 8,9,10
    	
    	return true;
    }

    @Override
    public AssetListDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    public boolean updateLocation(Map param) {
		return mapper.updateAsset(param) > 0;
	}

    @Override
    public boolean update(Map param) {
    	
    	Map chParam = new HashMap<>();
    	chParam.putAll(param);
    	if("2".equals(String.valueOf(param.get("asset_kind_id_hid")))) {//2:구조물경사계
    		
			//계산수식, 관리기준값
			mapper.deleteCalc(param);
			mapper.deleteManage(param);
    		
    		//채널
    		mapper.deleteChannel(param);
    		
    		String name = String.valueOf(chParam.get("name"));
    		
    		chParam.put("name", name+"-X");
			chParam.put("seq", "0");
			chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_1")));
			mapper.insertChannel(chParam);

			//계산수식, 관리기준값
			mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
			//채널
			chParam.put("name", name+"-Y");
			chParam.put("seq", "1");
			chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_2")));
			mapper.insertChannel(chParam);
			
			//계산수식, 관리기준값
			mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
    	}else if("3".equals(String.valueOf(param.get("asset_kind_id_hid")))
    			|| "4".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
    			|| "6".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
    			|| "7".equals(String.valueOf(param.get("asset_kind_id_hid"))) ){//3:지표변위계, 4:강우량계, 6:지하수위계(6), 7:지하수위계(7)
    		
			//계산수식, 관리기준값
			mapper.deleteCalc(param);
			mapper.deleteManage(param); 
    		
    		//채널
    		mapper.deleteChannel(param);

    		chParam.put("seq", "0");
    		chParam.put("sensor_id", String.valueOf(chParam.get("sensor_id_1")));
    		mapper.insertChannel(chParam);
    		
			//계산수식, 관리기준값
    		mapper.insertCalc(chParam);
			mapper.insertManage(chParam);
			
    	}
    	//else 8,9,10
    	
    	return mapper.updateAsset(param) > 0;
    }

    @Override
    public int delete(Map param) {
    	
    	if(	"2".equals(String.valueOf(param.get("asset_kind_id_hid"))) //2:구조물경사계
    		|| "3".equals(String.valueOf(param.get("asset_kind_id_hid")))
			|| "4".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
			|| "6".equals(String.valueOf(param.get("asset_kind_id_hid"))) 
			|| "7".equals(String.valueOf(param.get("asset_kind_id_hid"))) ){//3:지표변위계, 4:강우량계, 6:지하수위계(6), 7:지하수위계(7)
    		
    		mapper.deleteCalc(param);
    		mapper.deleteManage(param);
    		
    		mapper.deleteChannel(param);
    		
    	}
    	//else 8,9,10
    	
    	return mapper.deleteAsset(param);
    }
}
