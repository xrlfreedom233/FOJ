package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import top.hcode.hoj.pojo.entity.user.Auth;

import java.util.Date;
import java.util.List;
@Schema(name = "角色以及其对应的权限列表", description="")
@Data
public class RoleAuthsVO {

    @Schema(description = "角色id")
    private Long id;

    @Schema(description = "角色")
    private String role;

    @Schema(description = "描述")
    private String description;

    @Schema(description = "默认0可用，1不可用")
    private Integer status;

    @Schema(description = "创建时间")
    private Date gmtCreate;

    @Schema(description = "修改时间")
    private Date gmtModified;

    @Schema(description = "权限列表")
    private List<Auth> auths;
}