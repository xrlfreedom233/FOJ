package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
@Data
public class CaptchaVO {

    @Schema(description = "验证码图片的base64")
    private String img;

    @Schema(description = "验证码key")
    private String captchaKey;
}