package top.hcode.hoj.pojo.entity.user;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * 
 * </p>
 *
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Schema(name = "UserInfo对象", description="")
public class UserInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "uuid",type =IdType.ASSIGN_UUID)
    private String uuid;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "密码")
    private String password;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "昵称")
    private String nickname;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "学校")
    private String school;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "专业")
    private String course;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "学号")
    private String number;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "性别")
    private String gender;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "真实姓名")
    private String realname;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "cf的username")
    private String cfUsername;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "github地址")
    private String github;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "博客地址")
    private String blog;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "头像地址")
    private String avatar;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    @Schema(description = "个性介绍")
    private String signature;

    @Schema(description = "头衔、称号")
    private String titleName;

    @Schema(description = "头衔、称号的颜色")
    private String titleColor;

    @Schema(description = "0可用，-1不可用")
    private int status;

    @Schema(description = "cf得分")
    private Integer rating;

//    @Schema(description = "是否为比赛账号")
//    private Boolean isContest;

    @Schema(description = "创建时间")
    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @Schema(description = "修改时间")
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;


}
