package top.hcode.hoj.config;

import lombok.Data;
@Data
public class WebConfig {

    // 邮箱配置
    private String emailUsername;

    private String emailPassword;

    private String emailHost;

    private Integer emailPort;

    private Boolean emailSsl = true;

    private String emailBGImg = "";

    // 网站前端显示配置
    private String baseUrl = "";

    private String name = "FOJ";

    private String shortName = "FOJ";

    private String description;

    private Boolean register = true;

    private Boolean registerEmailBypass = false;

    private String recordName;

    private String recordUrl;

    private String projectName = "FOJ";

    private String projectUrl = "";
}
