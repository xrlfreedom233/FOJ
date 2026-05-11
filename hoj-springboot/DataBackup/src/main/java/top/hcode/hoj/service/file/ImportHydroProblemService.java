package top.hcode.hoj.service.file;

import org.springframework.web.multipart.MultipartFile;
import top.hcode.hoj.common.result.CommonResult;
public interface ImportHydroProblemService {

    public CommonResult<Void> importHydroProblem(MultipartFile file);
}
