package top.hcode.hoj.pojo.vo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;
@Schema(name = "比赛信息", description="")
@Data
public class ContestVO implements Serializable {

    @TableId(value = "比赛id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "创建者用户名")
    private String author;

    @Schema(description = "比赛标题")
    private String title;

    @Schema(description = "0为acm赛制，1为比分赛制")
    private Integer type;

    @Schema(description = "比赛说明")
    private String description;

    @Schema(description = "-1为未开始，0为进行中，1为已结束")
    private Integer status;

    @Schema(description = "比赛来源，原创为0，克隆赛为比赛id")
    private Integer source;

    @Schema(description = "0为公开赛，1为私有赛（有密码），2为保护赛")
    private Integer auth;

    @Schema(description = "当前服务器系统时间，为了前端统一时间")
    private Date now;

    @Schema(description = "开始时间")
    private Date startTime;

    @Schema(description = "结束时间")
    private Date endTime;

    @Schema(description = "比赛时长（秒）")
    private Integer duration;

    @Schema(description = "是否开启封榜")
    private Boolean sealRank;

    @Schema(description = "是否打开打印功能")
    private Boolean openPrint;

    @Schema(description = "封榜起始时间，一直到比赛结束，不刷新榜单")
    private Date sealRankTime;

    @Schema(description = "排行榜显示（username、nickname、realname）")
    private String rankShowName;

    @Schema(description = "是否开放比赛榜单")
    private Boolean openRank;

    @Schema(description = "oi排行榜得分方式，Recent、Highest（最近一次提交、最高得分提交）")
    private String oiRankScoreType;

    @Schema(description = "比赛的报名人数")
    private Integer count;

    @Schema(description = "是否允许比赛结束后继续交题")
    private Boolean allowEndSubmit;
}