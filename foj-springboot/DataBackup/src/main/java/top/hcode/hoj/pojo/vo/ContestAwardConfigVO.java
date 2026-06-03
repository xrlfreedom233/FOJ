package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
@Schema(name = "比赛奖项配置", description="")
@Data
public class ContestAwardConfigVO {

    @Schema(description = "优先级")
    private Integer priority;

    @Schema(description = "奖项名称")
    private String name;

    @Schema(description = "背景颜色")
    private String background;

    @Schema(description = "文本颜色")
    private String color;

    @Schema(description = "数量")
    private Integer num;

}
