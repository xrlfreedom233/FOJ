package top.hcode.hoj.shiro;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @Description: 存在redis session的当前登录用户信息
 */
@Data
public class AccountProfile implements Serializable {

    @Schema(description = "用户id")
    private String uid;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "真实姓名")
    private String realname;

    @Schema(description = "头衔名称")
    private String titleName;

    @Schema(description = "头衔背景颜色")
    private String titleColor;

    @Schema(description = "头像地址")
    private String avatar;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "0可用，1不可用")
    private int status;

    @Schema(description = "创建时间")
    private Date gmtCreate;

    public String getId() { //shiro登录用户实体默认主键获取方法要为getId
        return uid;
    }
}
