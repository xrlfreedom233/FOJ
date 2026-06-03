package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;
import java.util.List;
@Schema(name = "管理比赛的回传实体", description="")
@Data
public class AdminContestVO {

    @Schema(description = "比赛id")
    private Long id;

    @Schema(description = "比赛创建者id")
    private String uid;

    @Schema(description = "比赛创建者的用户名")
    private String author;

    @Schema(description = "比赛标题")
    private String title;

    @Schema(description = "0为acm赛制，1为比分赛制")
    private Integer type;

    @Schema(description = "比赛说明")
    private String description;

    @Schema(description = "比赛来源，原创为0，克隆赛为比赛id")
    private Integer source;

    @Schema(description = "0为公开赛，1为私有赛（访问有密码），2为保护赛（提交有密码）")
    private Integer auth;

    @Schema(description = "比赛密码")
    private String pwd;

    @Schema(description = "开始时间")
    private Date startTime;

    @Schema(description = "结束时间")
    private Date endTime;

    @Schema(description = "比赛时长（s）")
    private Long duration;

    @Schema(description = "是否开启封榜")
    private Boolean sealRank;

    @Schema(description = "封榜起始时间，一直到比赛结束，不刷新榜单")
    private Date sealRankTime;

    @Schema(description = "比赛结束是否自动解除封榜,自动转换成真实榜单")
    private Boolean autoRealRank;

    @Schema(description = "-1为未开始，0为进行中，1为已结束")
    private Integer status;

    @Schema(description = "是否可见")
    private Boolean visible;

    @Schema(description = "是否打开打印功能")
    private Boolean openPrint;

    @Schema(description = "是否打开账号限制")
    private Boolean openAccountLimit;

    @Schema(description = "账号限制规则 <prefix>**</prefix><suffix>**</suffix><start>**</start><end>**</end><extra>**</extra>")
    private String accountLimitRule;

    @Schema(description = "排行榜显示（username、nickname、realname）")
    private String rankShowName;

    @Schema(description = "打星用户列表")
    private List<String> starAccount;

    @Schema(description = "是否开放比赛榜单")
    private Boolean openRank;

    @Schema(description = "oi排行榜得分方式，Recent、Highest（最近一次提交、最高得分提交）")
    private String oiRankScoreType;

    @Schema(description = "奖项类型：0(不设置),1(设置占比),2(设置人数)")
    private Integer awardType;

    @Schema(description = "奖项配置")
    private List<ContestAwardConfigVO> awardConfigList;

    @Schema(description = "是否允许比赛结束后继续交题")
    private Boolean allowEndSubmit;

    private Date gmtCreate;

    private Date gmtModified;

}