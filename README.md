# FOJ

基于 Vue + Spring Boot + Spring Cloud Alibaba 的前后端分离在线评测系统。

## 技术栈

- 前端：Vue 3 + TypeScript + Vite + Pinia + Tailwind（`foj-api-vue3`）
- 后端：Spring Boot 3.5 + Java 17 + Spring Cloud / Spring Cloud Alibaba 2025 + Nacos + MySQL + Redis
- 沙盒：go-judge

## 模块

| 目录 | 说明 |
|---|---|
| `foj-api-vue3` | 前端（Vue 3 + TypeScript + Pinia + Tailwind） |
| `foj-springboot/DataBackup` | 后端主服务（API） |
| `foj-springboot/JudgeServer` | 判题服务 |
| `foj-springboot/common` | 公共实体/接口模块 |
| `sandbox` | go-judge 安全沙盒可执行文件 |
| `sqlAndsetting` | 数据库初始化脚本 |
| `foj-deploy` | Docker 部署脚本 |

## 本地开发

### 前端

```bash
cd foj-api-vue3
npm install
npm run dev
# http://localhost:3000（dev server 把 /api 代理到后端 127.0.0.1:6688）
```

### 后端

需要先有 MySQL、Redis、Nacos。最简单方式：用 `foj-deploy/standAlone` 起一份 Docker，再本地用 IDE 跑 DataBackup / JudgeServer 连过去。

## 协议

MIT。本项目基于 [HOJ](https://github.com/HimitZH/HOJ)（MIT）改造。
