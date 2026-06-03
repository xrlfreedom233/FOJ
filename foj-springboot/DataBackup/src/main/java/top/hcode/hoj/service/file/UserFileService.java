package top.hcode.hoj.service.file;

import jakarta.servlet.http.HttpServletResponse;
import top.hcode.hoj.common.exception.StatusFailException;

import java.io.IOException;

public interface UserFileService {

    public void generateUserExcel(String key, HttpServletResponse response) throws IOException, StatusFailException;
}
