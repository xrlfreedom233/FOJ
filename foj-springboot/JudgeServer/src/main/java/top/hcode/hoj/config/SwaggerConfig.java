package top.hcode.hoj.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile({"dev", "test"}) // 只允许开发环境访问
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("FOJ-JudgeServer的API文档")
                        .description("FOJ的判题端接口文档")
                        .version("v4.4")
                        .termsOfService("https://docs.hdoi.cn")
                        .contact(new Contact().name("FOJ"))
                        .license(new License().name("MIT").url("http://www.apache.org/licenses/LICENSE-2.0")));
    }
}
