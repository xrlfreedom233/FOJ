package top.hcode.hoj.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SwitchConfigDTO {

    /**
     * 是否开启公开评论区
     */
    private Boolean openPublicDiscussion;

    /**
     * 是否开启比赛讨论区
     */
    private Boolean openContestComment;

    /**
     * 是否开启公开评测
     */
    private Boolean openPublicJudge;

    /**
     * 是否开启比赛评测
     */
    private Boolean openContestJudge;

    /**
     * 是否隐藏非比赛提交详情的代码(超管不受限制)
     */
    private Boolean hideNonContestSubmissionCode;

    /**
     * 非比赛的提交间隔秒数
     */
    private Integer defaultSubmitInterval;

    /**
     * 每天可以创建的帖子数量
     */
    private Integer defaultCreateDiscussionDailyLimit;

    /**
     * 创建讨论帖子的前提
     */
    private Integer defaultCreateDiscussionACInitValue;

    /**
     * 评论和回复的前提
     */
    private Integer defaultCreateCommentACInitValue;

}
