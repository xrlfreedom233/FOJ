package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import top.hcode.hoj.pojo.entity.judge.Judge;
@Data
public class SubmissionInfoVO {

    @Schema(description = "提交详情")
    private Judge submission;

    @Schema(description = "提交者是否可以分享该代码")
    private Boolean codeShare;

    @Schema(description = "题目展示id")
    private String displayPid;

    @Schema(description = "题目标题")
    private String title;
}
