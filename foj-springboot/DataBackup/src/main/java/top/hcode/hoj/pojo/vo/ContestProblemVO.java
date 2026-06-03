package top.hcode.hoj.pojo.vo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
@Schema(name = "比赛题目列表格式数据ContestProblemVO", description = "")
@Data
public class ContestProblemVO implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "该题目在比赛中的顺序id")
    private String displayId;

    @Schema(description = "比赛id")
    private Long cid;

    @Schema(description = "题目id")
    private Long pid;

    @Schema(description = "该题目在比赛中的标题，默认为原名字")
    private String displayTitle;

    @Schema(description = "该题目在比赛中的气球颜色")
    private String color;

    @Schema(description = "该题目的ac通过数")
    private Integer ac;

    @Schema(description = "该题目的总提交数")
    private Integer total;
}