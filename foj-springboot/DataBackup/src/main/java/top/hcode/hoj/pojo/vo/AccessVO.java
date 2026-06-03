package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
@Data
public class AccessVO {

    @Schema(description = "是否有进入比赛或训练的权限")
    private Boolean access;
}