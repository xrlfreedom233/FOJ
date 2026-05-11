package top.hcode.hoj.dao.user.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import top.hcode.hoj.mapper.SessionMapper;
import top.hcode.hoj.pojo.entity.user.Session;
import top.hcode.hoj.dao.user.SessionEntityService;

@Service
public class SessionEntityServiceImpl extends ServiceImpl<SessionMapper, Session> implements SessionEntityService {

    @Override
    @Async
    public void checkRemoteLogin(String uid) {
        // remote login notification removed along with notice module
    }
}
