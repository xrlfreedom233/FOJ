package top.hcode.hoj.pojo.dto;

import lombok.Data;
import top.hcode.hoj.pojo.entity.common.Announcement;

import jakarta.validation.constraints.NotBlank;
@Data
public class AnnouncementDTO {
    @NotBlank(message = "比赛id不能为空")
    private Long cid;

    private Announcement announcement;
}