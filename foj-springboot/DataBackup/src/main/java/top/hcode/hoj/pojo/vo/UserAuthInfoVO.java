package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;
import java.util.List;
@Data
public class UserAuthInfoVO {

    @Schema(description = "角色列表")
    private List<String> roles;

    @Schema(description = "权限列表")
    private List<String> permissions;

    @Schema(description = "头像地址")
    private String avatar;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "创建时间")
    private Date gmtCreate;
}
