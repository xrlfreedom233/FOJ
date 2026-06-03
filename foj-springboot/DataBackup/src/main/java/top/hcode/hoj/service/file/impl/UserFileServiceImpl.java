package top.hcode.hoj.service.file.impl;

import org.springframework.stereotype.Service;
import top.hcode.hoj.common.exception.StatusFailException;
import top.hcode.hoj.manager.file.UserFileManager;
import top.hcode.hoj.service.file.UserFileService;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
@Service
public class UserFileServiceImpl implements UserFileService {

    @Resource
    private UserFileManager userFileManager;


    @Override
    public void generateUserExcel(String key, HttpServletResponse response) throws IOException, StatusFailException {
        userFileManager.generateUserExcel(key, response);
    }
}
