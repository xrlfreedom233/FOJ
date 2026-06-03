package top.hcode.hoj.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import top.hcode.hoj.shiro.ShiroConstant;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;


@Slf4j(topic = "hoj")
@Data
@Component
public class JwtUtils {

    @Value("${hoj.jwt.secret:${jwt-token-secret:default}}")
    private String secret;

    @Value("${hoj.jwt.expire:${jwt-token-expire:86400}}")
    private long expire;

    @Value("${hoj.jwt.header:Authorization}")
    private String header;

    @Value("${hoj.jwt.checkRefreshExpire:${jwt-token-fresh-expire:43200}}")
    private long checkRefreshExpire;

    @Autowired
    private RedisUtils redisUtils;

    /**
     * 生成jwt token
     */
    public String generateToken(String userId) {
        Date nowDate = new Date();
        //过期时间
        Date expireDate = new Date(nowDate.getTime() + expire * 1000);

        String token = Jwts.builder()
                .header().add("type", "JWT").and()
                .subject(userId)
                .issuedAt(nowDate)
                .expiration(expireDate)
                .signWith(signingKey(), Jwts.SIG.HS512)
                .compact();
        redisUtils.set(ShiroConstant.SHIRO_TOKEN_KEY + userId, token, expire);
        redisUtils.set(ShiroConstant.SHIRO_TOKEN_REFRESH + userId, "1", checkRefreshExpire);
        return token;
    }

    public Claims getClaimByToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(signingKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (Exception e) {
            log.debug("validate is token error ", e);
            return null;
        }
    }

    public void cleanToken(String uid) {
        redisUtils.del(ShiroConstant.SHIRO_TOKEN_KEY + uid, ShiroConstant.SHIRO_TOKEN_REFRESH + uid);
    }

    public boolean hasToken(String uid) {
        return redisUtils.hasKey(ShiroConstant.SHIRO_TOKEN_KEY + uid);
    }

    /**
     * token是否过期
     *
     * @return true：过期
     */
    public boolean isTokenExpired(Date expiration) {
        return expiration.before(new Date());
    }

    private SecretKey signingKey() {
        try {
            byte[] keyBytes = MessageDigest.getInstance("SHA-512")
                    .digest(secret.getBytes(StandardCharsets.UTF_8));
            return Keys.hmacShaKeyFor(keyBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-512 is not available", e);
        }
    }

}
