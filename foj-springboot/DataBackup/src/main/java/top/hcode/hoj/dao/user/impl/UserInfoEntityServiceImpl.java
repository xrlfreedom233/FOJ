package top.hcode.hoj.dao.user.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import top.hcode.hoj.mapper.JudgeMapper;
import top.hcode.hoj.pojo.dto.RegisterDTO;
import top.hcode.hoj.pojo.entity.judge.Judge;
import top.hcode.hoj.pojo.entity.user.UserInfo;
import top.hcode.hoj.mapper.UserInfoMapper;
import top.hcode.hoj.dao.user.UserInfoEntityService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import top.hcode.hoj.pojo.vo.ACMRankVO;
import top.hcode.hoj.pojo.vo.OIRankVO;
import top.hcode.hoj.pojo.vo.UserHomeVO;
import top.hcode.hoj.utils.AvatarUtils;
import top.hcode.hoj.utils.Constants;
import top.hcode.hoj.utils.RedisUtils;

import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 */
@Service
public class UserInfoEntityServiceImpl extends ServiceImpl<UserInfoMapper, UserInfo> implements UserInfoEntityService {

    @Autowired
    private UserInfoMapper userInfoMapper;

    @Autowired
    private JudgeMapper judgeMapper;

    @Autowired
    private RedisUtils redisUtils;

    @Override
    public Boolean addUser(RegisterDTO registerDto) {
        return userInfoMapper.addUser(registerDto) == 1;
    }

    @Override
    public List<String> getSuperAdminUidList() {

        String cacheKey = Constants.Account.SUPER_ADMIN_UID_LIST_CACHE.getCode();
        List<String> superAdminUidList = (List<String>) redisUtils.get(cacheKey);
        if (superAdminUidList == null) {
            superAdminUidList = userInfoMapper.getSuperAdminUidList();
            redisUtils.set(cacheKey, superAdminUidList, 12 * 3600);
        }
        return superAdminUidList;
    }

    @Override
    public List<String> getProblemAdminUidList() {
        return userInfoMapper.getProblemAdminUidList();
    }

    @Override
    public List<ACMRankVO> getRecent7ACRank() {
        List<ACMRankVO> rankList = userInfoMapper.getRecent7ACRank();
        rankList.forEach(user -> user.setAvatar(AvatarUtils.resolveAvatar(user.getAvatar(), user.getEmail())));
        return rankList;
    }

    @Override
    public UserHomeVO getUserHomeInfo(String uid, String username) {
        UserHomeVO userHome = userInfoMapper.getUserHomeInfo(uid, username);
        if (userHome != null) {
            userHome.setAvatar(AvatarUtils.resolveAvatar(userHome.getAvatar(), userHome.getEmail()));
        }
        return userHome;
    }

    @Override
    public List<Judge> getLastYearUserJudgeList(String uid, String username) {
        return judgeMapper.getLastYearUserJudgeList(uid, username);
    }

    @Override
    public IPage<OIRankVO> getOIRankList(Page<OIRankVO> page, List<String> uidList) {
        IPage<OIRankVO> rankPage = userInfoMapper.getOIRankList(page, uidList);
        rankPage.getRecords().forEach(user -> user.setAvatar(AvatarUtils.resolveAvatar(user.getAvatar(), user.getEmail())));
        return rankPage;
    }

    @Override
    public IPage<ACMRankVO> getACMRankList(Page<ACMRankVO> page, List<String> uidList) {
        IPage<ACMRankVO> rankPage = userInfoMapper.getACMRankList(page, uidList);
        rankPage.getRecords().forEach(user -> user.setAvatar(AvatarUtils.resolveAvatar(user.getAvatar(), user.getEmail())));
        return rankPage;
    }
}
