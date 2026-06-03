package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
@Data
@Schema(name = "比赛报名统计", description="")
public class ContestRegisterCountVO implements Serializable {

    @Schema(description = "比赛id")
    private Long cid;

    @Schema(description = "比赛报名人数")
    private Integer count;
}