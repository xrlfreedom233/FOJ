package top.hcode.hoj.config;

import com.alibaba.cloud.nacos.NacosDiscoveryProperties;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import top.hcode.hoj.util.IpUtils;

import java.util.HashMap;
@Configuration
public class NacosConfig {

    private static final int cpuNum = Runtime.getRuntime().availableProcessors();


    @Value("${hoj-judge-server.max-task-num}")
    private Integer maxTaskNum;

    @Value("${hoj-judge-server.ip}")
    private String ip;

    @Value("${hoj-judge-server.port}")
    private Integer port;

    @Value("${hoj-judge-server.name}")
    private String name;

    @Value("${hoj-judge-server.nacos-url}")
    private String nacosUrl;

    @Value("${spring.cloud.nacos.discovery.username:}")
    private String nacosUsername;

    @Value("${spring.cloud.nacos.discovery.password:}")
    private String nacosPassword;

    /**
     * 用于改变程序自动获取的本机ip
     */
    @Bean
    @Primary
    public NacosDiscoveryProperties nacosProperties() {
        NacosDiscoveryProperties nacosDiscoveryProperties = new NacosDiscoveryProperties();
        nacosDiscoveryProperties.setServerAddr(nacosUrl);
        nacosDiscoveryProperties.setUsername(nacosUsername);
        nacosDiscoveryProperties.setPassword(nacosPassword);
        nacosDiscoveryProperties.setRegisterEnabled(true);
        nacosDiscoveryProperties.setInstanceEnabled(true);
        //此处我只改了ip，其他参数可以根据自己的需求改变
        nacosDiscoveryProperties.setIp(IpUtils.getServiceIp());
        HashMap<String, String> meta = new HashMap<>();
        int max = cpuNum * 2 + 1;
        if (maxTaskNum != -1) {
            max = maxTaskNum;
        }
        meta.put("maxTaskNum", String.valueOf(max));
        meta.put("judgeName", name);
        nacosDiscoveryProperties.setMetadata(meta);
        if (!ip.equals("-1")) {
            nacosDiscoveryProperties.setIp(ip);
        }
        nacosDiscoveryProperties.setPort(port);

        nacosDiscoveryProperties.setService("hoj-judge-server");
        return nacosDiscoveryProperties;
    }

}
