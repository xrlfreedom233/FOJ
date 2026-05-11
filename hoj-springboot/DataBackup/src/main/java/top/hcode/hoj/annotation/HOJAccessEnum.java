package top.hcode.hoj.annotation;
public enum HOJAccessEnum {

    /**
     * 公共评测
     */
    PUBLIC_JUDGE,

    /**
     * 团队评测
     */
    GROUP_JUDGE,

    /**
     * 比赛评测
     */
    CONTEST_JUDGE,

    /**
     * 隐藏非比赛提交详情的代码
     */
    HIDE_NON_CONTEST_SUBMISSION_CODE
}
