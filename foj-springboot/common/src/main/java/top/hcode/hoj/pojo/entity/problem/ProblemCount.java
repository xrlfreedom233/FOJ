package top.hcode.hoj.pojo.entity.problem;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * 
 * </p>
 *
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Schema(name = "ProblemCount对象", description="")
public class ProblemCount implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "pid", type = IdType.ASSIGN_ID)
    private Long pid;

    private Integer total;

    private Integer ac;

    @Schema(description = "空间超限")
    private Integer mle;

    @Schema(description = "时间超限")
    private Integer tle;

    @Schema(description = "运行错误")
    private Integer re;

    @Schema(description = "格式错误")
    private Integer pe;

    @Schema(description = "编译错误")
    private Integer ce;

    @Schema(description = "答案错误")
    private Integer wa;

    @Schema(description = "系统错误")
    private Integer se;

    @Schema(description = "部分通过，OI题目")
    private Integer pa;

    @Version
    private Long version;

    @TableField(fill = FieldFill.INSERT)
    private Date gmtCreate;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date gmtModified;


}
