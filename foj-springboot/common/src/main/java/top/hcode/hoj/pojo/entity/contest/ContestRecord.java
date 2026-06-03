package top.hcode.hoj.pojo.entity.contest;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
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
@Schema(name = "ContestRecord对象", description="")
public class ContestRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "比赛id")
    private Long cid;

    @Schema(description = "用户id")
    private String uid;

    @Schema(description = "题目id")
    private Long pid;

    @Schema(description = "比赛中的题目id")
    private Long cpid;

    @Schema(description = "比赛中展示的id")
    private String displayId;

    @Schema(description = "提交id，用于可重判")
    private Long submitId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "真实姓名（废弃）")
    private String realname;

    @Schema(description = "提交结果，0表示未AC通过不罚时，1表示AC通过，-1为未AC通过算罚时")
    private Integer status;

    @Schema(description = "具体提交时间")
    private Date submitTime;

    @Schema(description = "提交时间，为提交时间减去比赛时间")
    private Long time;

    @Schema(description = "OI比赛的得分")
    private Integer score;

    @Schema(description = "提交的程序运行耗时")
    private Integer useTime;

    @Schema(description = "是否为一血AC（废弃）")
    private Boolean firstBlood;

    @Schema(description = "AC是否已校验")
    private Boolean checked;

    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;

}
