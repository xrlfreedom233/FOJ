package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
@Data
public class RandomProblemVO {

    @Schema(description = "题目id")
    private String problemId;
}