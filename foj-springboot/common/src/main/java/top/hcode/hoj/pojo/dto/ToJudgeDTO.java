package top.hcode.hoj.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import top.hcode.hoj.pojo.entity.judge.Judge;

import java.io.Serializable;
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class ToJudgeDTO implements Serializable {

    private static final long serialVersionUID = 999L;

    /**
     *  判题数据实体类
     */
    private Judge judge;

    /**
     *  调用评测验证的token
     */
    private String token;

}