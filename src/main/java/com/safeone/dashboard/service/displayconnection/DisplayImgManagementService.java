package com.safeone.dashboard.service.displayconnection;

import com.safeone.dashboard.dao.displayconnection.DisplayImgManagementMapper;
import com.safeone.dashboard.dto.displayconnection.DisplayImgManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class DisplayImgManagementService implements JqGridService<DisplayImgManagementDto> {

    private final DisplayImgManagementMapper mapper;

    @Override
    public List<DisplayImgManagementDto> getList(Map param) {
        return mapper.selectDisplayImgManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectDisplayImgManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        validateCreateParam(param);
        boolean imageInserted = mapper.insertDisplayImgManagement(param);
        boolean mappingInserted = mapper.insertDisplayMapping(param);
        if (!imageInserted || !mappingInserted) {
            throw new RuntimeException("Display image/mapping insert failed");
        }
        return true;
    }

    @Override
    public DisplayImgManagementDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateDisplayImgManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteDisplayImgManagement(param);
    }

    public boolean createGroup(Map<String, Object> param) {
        return mapper.insertGroup(param);
    }

    private void validateCreateParam(Map param) {
        requireText(param, "img_grp_nm", "전송그룹이 누락되었습니다.");
        requireText(param, "dispbd_imgfile_nm", "이미지 파일명이 누락되었습니다.");
        requireText(param, "img_file_path", "이미지 데이터가 누락되었습니다.");
        requireText(param, "dispbd_evnt_flag", "이벤트 구분이 누락되었습니다.");
        requireText(param, "img_effect_cd", "표시효과가 누락되었습니다.");
        requireText(param, "img_disp_min", "표시시간이 누락되었습니다.");
        requireText(param, "use_yn", "사용여부가 누락되었습니다.");
    }

    private void requireText(Map param, String key, String message) {
        Object value = param.get(key);
        if (value == null || value.toString().trim().isEmpty()) {
            throw new IllegalArgumentException(message);
        }
    }
}
