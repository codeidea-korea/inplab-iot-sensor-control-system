package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.UserMapper;
import com.safeone.dashboard.dto.UserDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserService implements JqGridService<UserDto> {

  private final UserMapper mapper;

  public UserDto getLoginSession(HttpServletRequest request) {
    HttpSession session = request.getSession();
    if (session.getAttribute("login") != null) {
      return (UserDto) session.getAttribute("login");
    } else {
      return null;
    }
  }

  @Override
  public List<UserDto> getList(Map param) {
    return mapper.selectUserList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectUserListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    return mapper.insertUser(param) > 0;
  }

  @Override
  public UserDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateUser(param) > 0;
  }

  @Override
  public int delete(Map param) {
    return mapper.deleteUser(param);
  }

  public UserDto getUserLogin(Map param) {
    mapper.expireUserIfNeeded(param);
    return mapper.selectUserLogin(param);
  }

  public String getLoginDenyReason(Map param) {
    return mapper.selectLoginDenyReason(param);
  }

  public boolean updateUserPassword(Map param) {
    return mapper.updatePassword(param) > 0;
  }
  public int isExists(Map param) {
    return mapper.isUserIdExists(param);
  }
}
