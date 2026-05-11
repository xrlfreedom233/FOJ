# FOJ

基于 Vue + Spring Boot + Spring Cloud Alibaba 的前后端分离在线评测系统。

## 技术栈

- 前端：Vue 2.6 + Vue CLI 5 (webpack 5) + Element UI
- 后端：Spring Boot 2.2 + Spring Cloud Alibaba + Nacos + MySQL + Redis
- 沙盒：go-judge

## 模块

| 目录 | 说明 |
|---|---|
| `hoj-vue` | 前端 |
| `hoj-springboot/DataBackup` | 后端主服务（API） |
| `hoj-springboot/JudgeServer` | 判题服务 |
| `hoj-springboot/api` | 公共实体/接口模块 |
| `sandbox` | go-judge 安全沙盒可执行文件 |
| `sqlAndsetting` | 数据库初始化脚本 |
| `hoj-deploy` | Docker 部署脚本 |
| `hoj-scrollBoard` | 滚榜工具 |

## 本地开发

### 前端

```bash
cd hoj-vue
npm install
npm run serve
# http://localhost:8066
```

### 后端

需要先有 MySQL、Redis、Nacos。最简单方式：用 `hoj-deploy/standAlone` 起一份 Docker，再本地用 IDE 跑 DataBackup / JudgeServer 连过去。

## 协议

MIT。本项目基于 [HOJ](https://github.com/HimitZH/HOJ)（MIT）改造。
