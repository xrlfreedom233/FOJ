package top.hcode.hoj.pojo.vo;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;
@Schema(name = "公告数据", description="")
@Data
public class AnnouncementVO {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "通知标题")
    private String title;

    @Schema(description = "通知内容")
    private String content;

    @Schema(description = "发布者（必须为比赛创建者或者超级管理员才能）")
    private String uid;

    @Schema(description = "发布者的用户名")
    private String username;

    @Schema(description = "0可见，1不可见")
    private int status;

    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;
}