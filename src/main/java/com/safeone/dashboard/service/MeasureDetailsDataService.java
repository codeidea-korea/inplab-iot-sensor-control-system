package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.MeasureDetailsDataMapper;
import com.safeone.dashboard.dto.MeasureDetailsDataDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class MeasureDetailsDataService implements JqGridService<MeasureDetailsDataDto> {

    private final MeasureDetailsDataMapper mapper;

    @Override
    public List<MeasureDetailsDataDto> getList(Map param) {
        return mapper.selectList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insert(param) > 0;
    }

    @Override
    public MeasureDetailsDataDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.update(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.delete(param);
    }

    public void createXYZ(Map param) {
        if (notNullAndNotEmpty(param.get("raw_data")) && notNullAndNotEmpty(param.get("formul_data"))) {
            param.put("sens_chnl_id", "");
            mapper.insert(param);
        }

        if (notNullAndNotEmpty(param.get("raw_data_x")) && notNullAndNotEmpty(param.get("formul_data_x"))) {
            param.put("sens_chnl_id", "X");
            param.put("raw_data", param.get("raw_data_x"));
            param.put("formul_data", param.get("formul_data_x"));
            mapper.insert(param);
        }

        if (notNullAndNotEmpty(param.get("raw_data_y")) && notNullAndNotEmpty(param.get("formul_data_y"))) {
            param.put("sens_chnl_id", "Y");
            param.put("raw_data", param.get("raw_data_y"));
            param.put("formul_data", param.get("formul_data_y"));
            mapper.insert(param);
        }

        if (notNullAndNotEmpty(param.get("raw_data_z")) && notNullAndNotEmpty(param.get("formul_data_z"))) {
            param.put("sens_chnl_id", "Z");
            param.put("raw_data", param.get("raw_data_z"));
            param.put("formul_data", param.get("formul_data_z"));
            mapper.insert(param);
        }
    }

    public boolean notNullAndNotEmpty(Object obj) {
        return obj != null && !obj.equals("");
    }

    public boolean nullOrEmpty(Object obj) {
        return obj == null || obj.equals("");
    }

    public void updateXYZ(Map param) {
        if (nullOrEmpty(param.get("raw_data")) && nullOrEmpty(param.get("formul_data"))) {
            param.put("sens_chnl_id", "");
            mapper.delete(param);
        }

        if (nullOrEmpty(param.get("raw_data_x")) && nullOrEmpty(param.get("formul_data_x"))) {
            param.put("sens_chnl_id", "X");
            mapper.delete(param);
        }

        if (nullOrEmpty(param.get("raw_data_y")) && nullOrEmpty(param.get("formul_data_y"))) {
            param.put("sens_chnl_id", "Y");
            mapper.delete(param);
        }

        if (nullOrEmpty(param.get("raw_data_z")) && nullOrEmpty(param.get("formul_data_z"))) {
            param.put("sens_chnl_id", "Z");
            mapper.delete(param);
        }

        if (notNullAndNotEmpty(param.get("raw_data")) && notNullAndNotEmpty(param.get("formul_data"))) {
            param.put("sens_chnl_id", "");
            if (isAlreadyExists(param)) {
                mapper.update(param);
            } else {
                mapper.delete(param);
                mapper.insert(param);
            }
        }

        if (notNullAndNotEmpty(param.get("raw_data_x")) && notNullAndNotEmpty(param.get("formul_data_x"))) {
            param.put("sens_chnl_id", "X");
            param.put("raw_data", param.get("raw_data_x"));
            param.put("formul_data", param.get("formul_data_x"));
            if (isAlreadyExists(param)) {
                mapper.update(param);
            } else {
                mapper.delete(param);
                mapper.insert(param);
            }
        }

        if (notNullAndNotEmpty(param.get("raw_data_y")) && notNullAndNotEmpty(param.get("formul_data_y"))) {
            param.put("sens_chnl_id", "Y");
            param.put("raw_data", param.get("raw_data_y"));
            param.put("formul_data", param.get("formul_data_y"));
            if (isAlreadyExists(param)) {
                mapper.update(param);
            } else {
                mapper.delete(param);
                mapper.insert(param);
            }
        }

        if (notNullAndNotEmpty(param.get("raw_data_z")) && notNullAndNotEmpty(param.get("formul_data_z"))) {
            param.put("sens_chnl_id", "Z");
            param.put("raw_data", param.get("raw_data_z"));
            param.put("formul_data", param.get("formul_data_z"));
            if (isAlreadyExists(param)) {
                mapper.update(param);
            } else {
                mapper.delete(param);
                mapper.insert(param);
            }
        }
    }

    private boolean isAlreadyExists(Map param) {
        return !mapper.isAlreadyExists(param).isEmpty();
    }

    public void deleteAll(Map param) {
        param.put("sens_no", param.get("sensNo").toString());
        mapper.deleteAll(param);
    }

    public void save(Map param, Object sensNo) {
        param.put("sens_no", sensNo);
        param.put("meas_dt", formattedDateTime(param.get("meas_dt").toString()));
        createXYZ(param);
    }

    private String formattedDateTime(String formattedDateTime) {
        String raw = formattedDateTime == null ? "" : formattedDateTime.trim();
        if (raw.isEmpty()) {
            return raw;
        }

        String normalized = raw
                .replace("T", "-")
                .replace(" ", "-")
                .replace(":", "-")
                .replace("/", "-")
                .replace(".", "-");
        String[] parts = normalized.split("-");
        if (parts.length < 5) {
            throw new IllegalArgumentException("Invalid meas_dt format: " + formattedDateTime);
        }

        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        int day = Integer.parseInt(parts[2]);
        int hour = Integer.parseInt(parts[3]);
        int minute = Integer.parseInt(parts[4]);
        int second = parts.length > 5 ? Integer.parseInt(parts[5]) : 0;

        return String.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second);
    }

    public void deleteRow(Map m) {
        mapper.deleteRow(m);
    }
}
