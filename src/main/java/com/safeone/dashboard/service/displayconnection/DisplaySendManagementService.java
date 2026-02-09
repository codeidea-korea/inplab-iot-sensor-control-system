package com.safeone.dashboard.service.displayconnection;

import com.safeone.dashboard.dao.displayconnection.DisplaySendManagementMapper;
import com.safeone.dashboard.dto.displayconnection.DisplayGroupDto;
import com.safeone.dashboard.dto.displayconnection.DisplaySendManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DisplaySendManagementService implements JqGridService<DisplaySendManagementDto> {

    private final DisplaySendManagementMapper mapper;

    @Override
    public List<DisplaySendManagementDto> getList(Map param) {
        return mapper.selectDisplaySendManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectDisplaySendManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertDisplaySendManagement(param);
    }

    @Override
    public DisplaySendManagementDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        int updated = mapper.updateDisplaySendManagement(param);

        if (param.get("use_yn") != null && param.get("dispbd_imgfile_nm") != null) {
            mapper.updateDisplayImageUseYnNew(param);
            if (param.get("dispbd_evnt_flag") != null && param.get("img_grp_nm") != null) {
                mapper.updateDisplayImageUseYnLegacy(param);
            }
        }

        return updated > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteDisplaySendManagement(param);
    }

    public List<DisplayGroupDto> group(Map<String, Object> param) {
        return mapper.selectDisplayGroupList(param);
    }
}
