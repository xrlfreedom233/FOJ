package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.HashMap;
@Data
@Accessors(chain = true)
public class OIContestRankVO {

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

    @Schema(description = "性别")
    private String gender;

    @Schema(description = "头像")
    private String avatar;

    @Schema(description = "学校")
    private String school;

    @Schema(description = "提交总得分")
    private Integer totalScore;

    @Schema(description = "提交总耗时，只有满分的提交才会统计")
    private Integer totalTime;

    @Schema(description = "OI的题对应提交得分")
    private HashMap<String, Integer> submissionInfo;

    @Schema(description = "OI的题得满分后对应提交最优耗时")
    private HashMap<String, Integer> timeInfo;
}