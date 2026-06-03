package top.hcode.hoj.manager.admin.user;

import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import top.hcode.hoj.common.exception.StatusFailException;
import top.hcode.hoj.dao.user.UserInfoEntityService;
import top.hcode.hoj.dao.user.UserRoleEntityService;
import top.hcode.hoj.pojo.dto.AdminEditUserDTO;
import top.hcode.hoj.pojo.entity.user.UserInfo;
import top.hcode.hoj.pojo.entity.user.UserRole;
import top.hcode.hoj.pojo.vo.ExcelUserVO;
import top.hcode.hoj.pojo.vo.UserRolesVO;
import top.hcode.hoj.shiro.AccountProfile;
import top.hcode.hoj.utils.Constants;
import top.hcode.hoj.utils.RedisUtils;

import java.util.*;
import java.util.stream.Collectors;
@Component
@Slf4j(topic = "hoj")
public class AdminUserManager {

    private static final Set<Integer> SIMPLE_ROLE_TYPES =
            new HashSet<>(Arrays.asList(1000, 1001, 1002));

    @Autowired
    private UserRoleEntityService userRoleEntityService;

    @Autowired
    private UserInfoEntityService userInfoEntityService;

    @Autowired
    private RedisUtils redisUtils;

    public IPage<UserRolesVO> getUserList(Integer limit, Integer currentPage, Boolean onlyAdmin, String keyword) {
        if (currentPage == null || currentPage < 1) currentPage = 1;
        if (limit == null || limit < 1) limit = 10;
        if (keyword != null) {
            keyword = keyword.trim();
        }
        return userRoleEntityService.getUserList(limit, currentPage, keyword, onlyAdmin);
    }

    public void editUser(AdminEditUserDTO adminEditUserDto) throws StatusFailException {

        String username = adminEditUserDto.getUsername();
        String uid = adminEditUserDto.getUid();
        String realname = adminEditUserDto.getRealname();
        String email = adminEditUserDto.getEmail();
        String password = adminEditUserDto.getPassword();
        int type = normalizeRoleType(adminEditUserDto.getType());
        int status = adminEditUserDto.getStatus();
        boolean setNewPwd = adminEditUserDto.getSetNewPwd();

        if (!StringUtils.isEmpty(realname) && realname.length() > 50) {
            throw new StatusFailException("真实姓名的长度不能超过50位");
        }

        if (!StringUtils.isEmpty(password) && (password.length() < 6 || password.length() > 20)) {
            throw new StatusFailException("密码长度建议为6~20位！");
        }

        if (username.length() > 20) {
            throw new StatusFailException("用户名长度建议不能超过20位!");
        }

        if (StrUtil.isBlank(email)) {
            email = null;
        } else {
            QueryWrapper<UserInfo> emailUserInfoQueryWrapper = new QueryWrapper<>();
            emailUserInfoQueryWrapper.select("uuid", "email")
                    .eq("email", email);
            UserInfo userInfo = userInfoEntityService.getOne(emailUserInfoQueryWrapper, false);
            if (userInfo != null && !Objects.equals(userInfo.getUuid(), adminEditUserDto.getUid())) {
                throw new StatusFailException("修改失败，邮箱已被使用，请重新设置其他邮箱！");
            }
        }

        QueryWrapper<UserRole> userRoleQueryWrapper = new QueryWrapper<>();
        userRoleQueryWrapper.eq("uid", uid);
        UserRole userRole = userRoleEntityService.getOne(userRoleQueryWrapper, false);
        if (userRole == null) {
            throw new StatusFailException("修改失败，该用户角色不存在！");
        }
        int oldType = userRole.getRoleId().intValue();

        AccountProfile currentUser = (AccountProfile) SecurityUtils.getSubject().getPrincipal();
        if (currentUser != null && Objects.equals(currentUser.getUid(), uid) && (type != oldType || status != 0)) {
            throw new StatusFailException("不能修改自己的角色或禁用自己的账号！");
        }
        if (oldType == 1000 && type != 1000 && countRootUsers() <= 1) {
            throw new StatusFailException("至少需要保留一个超级管理员！");
        }
        if (oldType == 1000 && status != 0 && countRootUsers() <= 1) {
            throw new StatusFailException("不能禁用最后一个超级管理员！");
        }

        UpdateWrapper<UserInfo> userInfoUpdateWrapper = new UpdateWrapper<>();
        userInfoUpdateWrapper.eq("uuid", uid)
                .set("username", username)
                .set("realname", realname)
                .set("email", email)
                .set(setNewPwd, "password", SecureUtil.md5(password))
                .set("status", status);
        boolean updateUserInfo = userInfoEntityService.update(userInfoUpdateWrapper);

        boolean changeUserRole = false;
        if (userRole.getRoleId().intValue() != type) {
            userRole.setRoleId((long) type);
            changeUserRole = userRoleEntityService.updateById(userRole);
            if (type == 1000 || oldType == 1000) {
                // 新增或者去除超级管理员需要删除缓存
                String cacheKey = Constants.Account.SUPER_ADMIN_UID_LIST_CACHE.getCode();
                redisUtils.del(cacheKey);
            }
        }
        if (updateUserInfo && setNewPwd) {
            // 需要重新登录
            userRoleEntityService.deleteCache(uid, true);
        } else if (changeUserRole) {
            // 需要重新授权
            userRoleEntityService.deleteCache(uid, false);
        }

        if (changeUserRole) {
            // 获取当前登录的用户
            AccountProfile userRolesVo = (AccountProfile) SecurityUtils.getSubject().getPrincipal();
        }

    }

    private int normalizeRoleType(Integer type) {
        if (type == null || !SIMPLE_ROLE_TYPES.contains(type)) {
            return 1002;
        }
        return type;
    }

    public void deleteUser(List<String> deleteUserIdList) throws StatusFailException {
        if (deleteUserIdList == null || deleteUserIdList.isEmpty()) {
            throw new StatusFailException("删除失败，用户列表不能为空！");
        }
        AccountProfile userRolesVo = (AccountProfile) SecurityUtils.getSubject().getPrincipal();
        if (userRolesVo != null && deleteUserIdList.contains(userRolesVo.getUid())) {
            throw new StatusFailException("不能删除当前登录账号！");
        }
        if (countRootUsersAfterDelete(deleteUserIdList) <= 0) {
            throw new StatusFailException("至少需要保留一个超级管理员！");
        }
        boolean isOk = userInfoEntityService.removeByIds(deleteUserIdList);
        if (!isOk) {
            throw new StatusFailException("删除失败！");
        }
        log.info("[{}],[{}],uidList:[{}],operatorUid:[{}],operatorUsername:[{}]",
                "Admin_User", "Delete", deleteUserIdList, userRolesVo.getUid(), userRolesVo.getUsername());
    }

    private long countRootUsers() {
        return userRoleEntityService.count(new QueryWrapper<UserRole>().eq("role_id", 1000));
    }

    private long countRootUsersAfterDelete(List<String> deleteUserIdList) {
        QueryWrapper<UserRole> queryWrapper = new QueryWrapper<UserRole>().eq("role_id", 1000);
        if (deleteUserIdList != null && !deleteUserIdList.isEmpty()) {
            queryWrapper.notIn("uid", deleteUserIdList);
        }
        return userRoleEntityService.count(queryWrapper);
    }

    public void insertBatchUser(List<List<String>> users) throws StatusFailException {
        List<String> successUidList = new LinkedList<>();
        if (users != null) {
            HashSet<String> failedUserNameSet = new HashSet<>();
            for (List<String> user : users) {
                try {
                    String uuid = addNewUser(user);
                    if (uuid != null) {
                        successUidList.add(uuid);
                    } else {
                        failedUserNameSet.add(user.get(0));
                    }
                } catch (Exception e) {
                    failedUserNameSet.add(user.get(0));
                }
            }
            // 异步同步系统通知 - removed with notice module
            if (failedUserNameSet.size() > 0) {
                int failedCount = failedUserNameSet.size();
                int successCount = users.size() - failedCount;
                String errMsg = "[导入结果] 成功数：" + successCount + ",  失败数：" + failedCount +
                        ",  失败的用户名：" + failedUserNameSet;
                throw new StatusFailException(errMsg);
            }
        } else {
            throw new StatusFailException("插入的用户数据不能为空！");
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public String addNewUser(List<String> user) throws StatusFailException {
        String uuid = IdUtil.simpleUUID();
        UserInfo userInfo = new UserInfo()
                .setUuid(uuid)
                .setUsername(user.get(0))
                .setPassword(SecureUtil.md5(user.get(1)))
                .setEmail(user.size() <= 2 || StringUtils.isEmpty(user.get(2)) ? null : user.get(2));

        if (user.size() >= 4) {
            String realname = user.get(3);
            if (!StringUtils.isEmpty(realname)) {
                userInfo.setRealname(user.get(3));
            }
        }

        if (user.size() >= 5) {
            String gender = user.get(4);
            if ("male".equals(gender.toLowerCase()) || "0".equals(gender)) {
                userInfo.setGender("male");
            } else if ("female".equals(gender.toLowerCase()) || "1".equals(gender)) {
                userInfo.setGender("female");
            }
        }

        if (user.size() >= 6) {
            String nickname = user.get(5);
            if (!StringUtils.isEmpty(nickname)) {
                userInfo.setNickname(nickname);
            }
        }

        if (user.size() >= 7) {
            String school = user.get(6);
            if (!StringUtils.isEmpty(school)) {
                userInfo.setSchool(school);
            }
        }


        boolean result1 = userInfoEntityService.save(userInfo);
        UserRole userRole = new UserRole()
                .setRoleId(1002L)
                .setUid(uuid);
        boolean result2 = userRoleEntityService.save(userRole);
        if (!result1 || !result2) {
            throw new StatusFailException("生成用户失败");
        }
        return uuid;
    }

    @Transactional(rollbackFor = Exception.class)
    public Map<Object, Object> generateUser(Map<String, Object> params) throws StatusFailException {

        String prefix = (String) params.getOrDefault("prefix", "");
        String suffix = (String) params.getOrDefault("suffix", "");
        int numberFrom = (int) params.getOrDefault("number_from", 1);
        int numberTo = (int) params.getOrDefault("number_to", 10);
        int passwordLength = (int) params.getOrDefault("password_length", 6);

        if (numberFrom > numberTo) {
            throw new StatusFailException("生成失败，结束编号不能小于起始编号！");
        }
        if (passwordLength < 6 || passwordLength > 25) {
            throw new StatusFailException("生成失败，密码长度需要在 6 到 25 之间！");
        }

        List<String> usernameList = new ArrayList<>();
        for (int num = numberFrom; num <= numberTo; num++) {
            usernameList.add(prefix + num + suffix);
        }
        List<UserInfo> existingUsers = userInfoEntityService.list(new QueryWrapper<UserInfo>()
                .select("username")
                .in("username", usernameList));
        if (!existingUsers.isEmpty()) {
            List<String> existingUsernameList = existingUsers.stream()
                    .map(UserInfo::getUsername)
                    .collect(Collectors.toList());
            throw new StatusFailException("生成失败，以下用户名已存在：" + existingUsernameList);
        }

        List<UserInfo> userInfoList = new LinkedList<>();
        List<UserRole> userRoleList = new LinkedList<>();
        List<Map<String, String>> generatedUserList = new LinkedList<>();

        HashMap<String, Object> userInfo = new HashMap<>(); // 存储账号密码放入redis中，等待导出excel
        for (String username : usernameList) {
            String uuid = IdUtil.simpleUUID();
            String password = RandomUtil.randomString(passwordLength);
            userInfoList.add(new UserInfo()
                    .setUuid(uuid)
                    .setUsername(username)
                    .setPassword(SecureUtil.md5(password)));
            userInfo.put(username, password);
            Map<String, String> generatedUser = new HashMap<>();
            generatedUser.put("username", username);
            generatedUser.put("password", password);
            generatedUserList.add(generatedUser);
            userRoleList.add(new UserRole()
                    .setRoleId(1002L)
                    .setUid(uuid));
        }
        boolean result1 = userInfoEntityService.saveBatch(userInfoList);
        boolean result2 = userRoleEntityService.saveBatch(userRoleList);
        if (result1 && result2) {
            String key = IdUtil.simpleUUID();
            boolean cacheOk = redisUtils.hmset(key, userInfo, 1800); // 存储半小时
            if (!cacheOk) {
                throw new StatusFailException("生成用户成功，但密码文件缓存失败，请检查 Redis 后重试！");
            }
            return MapUtil.builder()
                    .put("key", key)
                    .put("users", generatedUserList)
                    .map();
        } else {
            throw new StatusFailException("生成指定用户失败！注意查看组合生成的用户名是否已有存在的！");
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public List<ExcelUserVO> generateUserExcelRows(Map<String, Object> params) throws StatusFailException {
        Map<Object, Object> result = generateUser(params);
        Object users = result.get("users");
        if (!(users instanceof List<?> generatedUsers) || generatedUsers.isEmpty()) {
            throw new StatusFailException("用户已生成，但密码文件数据为空，请重新生成！");
        }

        List<ExcelUserVO> rows = new LinkedList<>();
        for (Object user : generatedUsers) {
            if (user instanceof Map<?, ?> generatedUser) {
                rows.add(new ExcelUserVO()
                        .setUsername(String.valueOf(generatedUser.get("username")))
                        .setPassword(String.valueOf(generatedUser.get("password"))));
            }
        }
        if (rows.isEmpty()) {
            throw new StatusFailException("用户已生成，但密码文件数据为空，请重新生成！");
        }
        return rows;
    }
}
