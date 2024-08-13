package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.UserDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface UserMapper {
    int selectUserListTotal(Map param);
    List<UserDto> selectUserList(Map param);
    int insertUser(Map param);
    int updateUser(Map param);
    int deleteUser(Map param);
    int isUserName(Map param);
    int isUserIdExists(Map param);
    UserDto selectUserLogin(Map param);
    int updatePassword(Map param);
}
    