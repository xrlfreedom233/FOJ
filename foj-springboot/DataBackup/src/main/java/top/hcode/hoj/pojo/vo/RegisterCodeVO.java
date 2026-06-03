package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
@Data
public class RegisterCodeVO {

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "注册邮件有效时间，单位秒")
    private Integer expire;

    @Schema(description = "开发模式注册验证码")
    private String code;
}
