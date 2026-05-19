package top.hcode.hoj.config;

import lombok.Data;

@Data
public class SwitchConfig {

    /**
     * 是否开启公开评测
     */
    private Boolean openPublicJudge = true;

    /**
     * 是否开启比赛评测
     */
    private Boolean openContestJudge = true;

    /**
     * 是否隐藏非比赛提交详情的代码（超管不受限制）
     */
    private Boolean hideNonContestSubmissionCode = false;

    /**
     * 非比赛的提交间隔秒数
     */
    private Integer defaultSubmitInterval = 8;
}
