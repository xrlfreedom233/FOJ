package top.hcode.hoj.pojo.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import top.hcode.hoj.pojo.entity.contest.ContestProblem;

import java.util.List;
@Schema(name = "赛外排行榜所需的比赛信息，同时包括题目题号、气球颜色", description = "")
@Data
public class ContestOutsideInfoVO {

    @Schema(description = "比赛信息")
    private ContestVO contest;

    @Schema(description = "比赛题目信息列表")
    private List<ContestProblem> problemList;
}