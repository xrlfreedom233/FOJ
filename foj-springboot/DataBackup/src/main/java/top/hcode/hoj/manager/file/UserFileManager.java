package top.hcode.hoj.manager.file;

import com.alibaba.excel.EasyExcel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import top.hcode.hoj.common.exception.StatusFailException;
import top.hcode.hoj.pojo.vo.ExcelUserVO;
import top.hcode.hoj.utils.RedisUtils;

import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
@Component
@Slf4j(topic = "hoj")
public class UserFileManager {

    @Autowired
    private RedisUtils redisUtils;

    public void generateUserExcel(String key, HttpServletResponse response) throws IOException, StatusFailException {
        List<ExcelUserVO> generatedUsers = getGenerateUsers(key);
        if (generatedUsers.isEmpty()) {
            throw new StatusFailException("生成用户密码文件已过期或不存在，请重新生成用户！");
        }
        writeGeneratedUsersExcel(generatedUsers, key, response);
    }

    public void writeGeneratedUsersExcel(List<ExcelUserVO> generatedUsers, String fileName, HttpServletResponse response) throws IOException, StatusFailException {
        if (generatedUsers == null || generatedUsers.isEmpty()) {
            throw new StatusFailException("密码文件数据为空，请重新生成用户！");
        }
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        EasyExcel.write(outputStream, ExcelUserVO.class).sheet("用户数据").doWrite(generatedUsers);
        byte[] bytes = outputStream.toByteArray();

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        // 这里URLEncoder.encode可以防止中文乱码
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8");
        response.setHeader("Content-disposition", "attachment;filename=" + encodedFileName + ".xlsx");
        response.setContentLength(bytes.length);
        response.getOutputStream().write(bytes);
        response.flushBuffer();
    }

    private List<ExcelUserVO> getGenerateUsers(String key) {
        List<ExcelUserVO> result = new LinkedList<>();
        if (key == null || key.trim().isEmpty()) {
            return result;
        }
        Map<Object, Object> userInfo = redisUtils.hmget(key);
        for (Object hashKey : userInfo.keySet()) {
            String username = (String) hashKey;
            String password = (String) userInfo.get(hashKey);
            result.add(new ExcelUserVO().setUsername(username).setPassword(password));
        }
        return result;
    }
}
