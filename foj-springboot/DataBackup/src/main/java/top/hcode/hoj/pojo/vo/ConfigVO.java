package top.hcode.hoj.pojo.vo;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;
@RefreshScope
@Data
@Component
public class ConfigVO {
    // 数据库配置
    @Value("${hoj.db.username:${mysql-username:root}}")
    private String mysqlUsername;

    @Value("${hoj.db.password:${mysql-password:}}")
    private String mysqlPassword;

    @Value("${hoj.db.name:${mysql-name:hoj}}")
    private String mysqlDBName;

    @Value("${hoj.db.host:${mysql-host:127.0.0.1}}")
    private String mysqlHost;

    @Value("${hoj.db.public-host:172.20.0.3}")
    private String mysqlPublicHost;

    @Value("${hoj.db.port:${mysql-port:3306}}")
    private Integer mysqlPort;

    @Value("${hoj.db.public-port:3306}")
    private Integer mysqlPublicPort;

    // 判题服务token
    @Value("${hoj.judge.token:no_judge_token}")
    private String judgeToken;

    // 缓存配置
    @Value("${hoj.redis.host:${redis-host:127.0.0.1}}")
    private String redisHost;

    @Value("${hoj.redis.port:${redis-port:6379}}")
    private Integer redisPort;

    @Value("${hoj.redis.password:${redis-password:}}")
    private String redisPassword;

    // jwt配置
    @Value("${hoj.jwt.secret:${jwt-token-secret:default_jwt_secret}}")
    private String tokenSecret;

    @Value("${hoj.jwt.expire:${jwt-token-expire:86400}}")
    private String tokenExpire;

    @Value("${hoj.jwt.checkRefreshExpire:${jwt-token-fresh-expire:43200}}")
    private String checkRefreshExpire;
}
