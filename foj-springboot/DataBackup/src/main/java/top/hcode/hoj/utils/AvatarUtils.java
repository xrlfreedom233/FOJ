package top.hcode.hoj.utils;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;

import java.util.Locale;

public class AvatarUtils {

    private static final String GRAVATAR_URL = "https://www.gravatar.com/avatar/%s?d=identicon&s=160";
    private static final String QQ_AVATAR_URL = "https://q1.qlogo.cn/g?b=qq&nk=%s&s=160";

    public static String resolveAvatar(String avatar, String email) {
        if (StrUtil.isNotBlank(avatar)) {
            return avatar;
        }
        if (StrUtil.isBlank(email)) {
            return "";
        }
        String normalizedEmail = email.trim().toLowerCase(Locale.ROOT);
        if (normalizedEmail.endsWith("@qq.com")) {
            String qq = normalizedEmail.substring(0, normalizedEmail.indexOf("@qq.com"));
            if (qq.chars().allMatch(Character::isDigit)) {
                return String.format(QQ_AVATAR_URL, qq);
            }
        }
        String hash = SecureUtil.md5(normalizedEmail);
        return String.format(GRAVATAR_URL, hash);
    }
}
