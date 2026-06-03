package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.HashMap;
@Data
@Accessors(chain = true)
public class ACMContestRankVO {

    @Schema(description = "排名,排名为-1则为打星队伍")
    private Integer rank;

    @Schema(description = "是否得奖")
    private Boolean isWinAward;

    @Schema(description = "排名奖项名称")
    private String awardName;

    @Schema(description = "排名背景颜色")
    private String awardBackground;

    @Schema(description = "排名文本颜色")
    private String awardColor;

    @Schema(description = "用户id")
    private String uid;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "用户真实姓名")
    private String realname;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "学校")
    private String school;

    @Schema(description = "性别")
    private String gender;

    @Schema(description = "头像")
    private String avatar;

    @Schema(description = "提交总罚时")
    private Long totalTime;

    @Schema(description = "总提交数")
    private Integer total;

    @Schema(description = "ac题目数")
    private Integer ac;

    @Schema(description = "有提交的题的提交详情")
    private HashMap<String,HashMap<String,Object>> submissionInfo;
}