package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.Date;
@Data
@Builder
public class RecentUpdatedProblemVO {

    @Schema(description = "主键id")
    private Long id;

    @Schema(description = "题目的自定义ID 例如（FOJ-1000）")
    private String problemId;

    @Schema(description = "题目")
    private String title;

    @Schema(description = "0为ACM,1为OI")
    private Integer type;

    @Schema(description = "创建时间")
    private Date gmtCreate;

    @Schema(description = "最近更新时间")
    private Date gmtModified;
}
