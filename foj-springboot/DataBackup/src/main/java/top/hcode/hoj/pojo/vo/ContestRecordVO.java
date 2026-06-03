package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;
@Schema(name = "用户在比赛的记录", description="")
@Data
public class ContestRecordVO implements Serializable {

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

    @Schema(description = "学校")
    private String school;

    @Schema(description = "性别")
    private String gender;

    @Schema(description = "头像")
    private String avatar;

    @Schema(description = "真实姓名")
    private String realname;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "提交结果，0表示未AC通过不罚时，1表示AC通过，-1为未AC通过算罚时")
    private Integer status;

    @Schema(description = "具体提交时间")
    private Date submitTime;

    @Schema(description = "提交时间，为提交时间减去比赛时间")
    private Long time;

    @Schema(description = "OI比赛的得分")
    private Integer score;

    @Schema(description = "提交耗时")
    private Integer useTime;

    @Schema(description = "AC是否已校验")
    private Boolean checked;

    private Date gmtCreate;

    private Date gmtModified;

}