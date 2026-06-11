/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.2.2-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: nacos
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Current Database: `nacos`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nacos` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `nacos`;

--
-- Table structure for table `config_info`
--

DROP TABLE IF EXISTS `config_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL,
  `content` longtext COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8mb3_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) COLLATE utf8mb3_bin DEFAULT NULL,
  `c_use` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `effect` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `type` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL,
  `c_schema` text COLLATE utf8mb3_bin,
  `encrypted_data_key` text COLLATE utf8mb3_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='config_info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `config_info` WRITE;
/*!40000 ALTER TABLE `config_info` DISABLE KEYS */;
INSERT INTO `config_info` VALUES
(1,'hoj-prod.yml','DEFAULT_GROUP','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token默认为24小时 86400s\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: hoj-judge-token-init\n  db:\n    host: 172.20.0.3\n    public-host: 172.20.0.3\n    port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  mail:\n    ssl: true\n    username: your_email_username\n    password: your_email_password\n    host: smtp.qq.com\n    port: 465\n    background-img: https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png\n  redis:\n    host: 172.20.0.2\n    port: 6379\n    password: hoj123456\n  web-config:\n    base-url: your_web_url\n    name: Hcode Online Judge\n    short-name: HOJ\n    description: Hcode Online Judge\n    register: true\n    footer:\n      record:\n        name: 2020-2021\n        url: your_record_url\n      project:\n        name: HOJ\n        url: https://gitee.com/himitzh0730/hoj\n  hdu:\n    account:\n      username:\n      password:\n  cf:\n    account:\n      username:\n      password:\n  poj:\n    account:\n      username:\n      password:\n  atcoder:\n    account:\n      username:\n      password:\n  spoj:\n    account:\n      username:\n      password:\n  switch:\n    judge:\n      public: true\n      group: true\n      contest: true\n      hide-non-contest-code: false\n      submit-interval: 8\n    discussion:\n      public: true\n      group: true\n      ac-initial-value: 10\n      create-daily: 5\n    comment:\n      contest: true\n      ac-initial-value: 10\n    group:\n      ac-initial-value: 20\n      create-total: 5\n','8b2e8491fb8cdf29c953f9a662d06e83','2026-05-26 16:08:01','2026-06-01 18:01:10','nacos','172.20.0.1','','',NULL,NULL,NULL,'yaml',NULL,''),
(2,'hoj-dev.yml','DEFAULT_GROUP','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3fa67e57cca74910aed18cc4df54556e\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','632e93059ad46ffb5878a73beb1590d0','2026-05-26 16:08:01','2026-06-01 05:09:16','nacos','172.20.0.1','','',NULL,NULL,NULL,'yaml',NULL,''),
(4,'hoj-web.yml','DEFAULT_GROUP','baseUrl: http://127.0.1.1\ndescription: null\nemailBGImg: \'\'\nemailHost: smtp.qq.com\nemailPassword: WAhYwt7TXKTb86s8\nemailPort: 465\nemailSsl: true\nemailUsername: xrlfreedom@163.com\nname: FOJ\nprojectName: FOJ\nprojectUrl: \'\'\nrecordName: null\nrecordUrl: null\nregister: true\nregisterEmailBypass: false\nshortName: FOJ\n','7582f54c0cf426408499a96856f3b92c','2026-05-12 19:59:24','2026-05-26 05:50:47','nacos','172.20.0.1','','',NULL,NULL,NULL,'yaml',NULL,''),
(31,'hoj-dev.yml','DEFAULT_GROUP','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 44fd324710d14241b076164efe4603d4\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','bb4f5ec6c52d611900f6167671311e9d','2026-06-02 00:58:13','2026-06-03 23:27:11',NULL,'192.168.31.187','','public',NULL,NULL,NULL,'yaml',NULL,'');
/*!40000 ALTER TABLE `config_info` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `config_info_aggr`
--

DROP TABLE IF EXISTS `config_info_aggr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_aggr` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'datum_id',
  `content` longtext COLLATE utf8mb3_bin NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='增加租户字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_aggr`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `config_info_aggr` WRITE;
/*!40000 ALTER TABLE `config_info_aggr` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_aggr` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `config_info_beta`
--

DROP TABLE IF EXISTS `config_info_beta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_beta` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8mb3_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text COLLATE utf8mb3_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='config_info_beta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_beta`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `config_info_beta` WRITE;
/*!40000 ALTER TABLE `config_info_beta` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_beta` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `config_info_tag`
--

DROP TABLE IF EXISTS `config_info_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8mb3_bin NOT NULL COMMENT 'content',
  `md5` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COLLATE utf8mb3_bin COMMENT 'source user',
  `src_ip` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='config_info_tag';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_tag`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `config_info_tag` WRITE;
/*!40000 ALTER TABLE `config_info_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_tag` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `config_tags_relation`
--

DROP TABLE IF EXISTS `config_tags_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_tags_relation` (
  `id` bigint NOT NULL COMMENT 'id',
  `tag_name` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`nid`),
  UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='config_tag_relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_tags_relation`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `config_tags_relation` WRITE;
/*!40000 ALTER TABLE `config_tags_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_tags_relation` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `group_capacity`
--

DROP TABLE IF EXISTS `group_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_capacity` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='集群、各Group容量信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_capacity`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `group_capacity` WRITE;
/*!40000 ALTER TABLE `group_capacity` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_capacity` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `his_config_info`
--

DROP TABLE IF EXISTS `his_config_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `his_config_info` (
  `id` bigint unsigned NOT NULL,
  `nid` bigint unsigned NOT NULL AUTO_INCREMENT,
  `data_id` varchar(255) COLLATE utf8mb3_bin NOT NULL,
  `group_id` varchar(128) COLLATE utf8mb3_bin NOT NULL,
  `app_name` varchar(128) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'app_name',
  `content` longtext COLLATE utf8mb3_bin NOT NULL,
  `md5` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL,
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `src_user` text COLLATE utf8mb3_bin,
  `src_ip` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL,
  `op_type` char(10) COLLATE utf8mb3_bin DEFAULT NULL,
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` text COLLATE utf8mb3_bin NOT NULL COMMENT '秘钥',
  PRIMARY KEY (`nid`),
  KEY `idx_gmt_create` (`gmt_create`),
  KEY `idx_gmt_modified` (`gmt_modified`),
  KEY `idx_did` (`data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='多租户改造';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `his_config_info`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `his_config_info` WRITE;
/*!40000 ALTER TABLE `his_config_info` DISABLE KEYS */;
INSERT INTO `his_config_info` VALUES
(2,1,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\r\n  jwt:\r\n    # 加密秘钥\r\n    secret: hoj-secret-init\r\n    # token默认为24小时 86400s\r\n    expire: 86400\r\n    checkRefreshExpire: 43200\r\n    header: token\r\n  judge:\r\n    # 调用判题服务器的token\r\n    token: hoj-judge-token-init\r\n  db:\r\n    host: 127.0.0.1\r\n    public-host: 127.0.0.1\r\n    port: 3306\r\n    name: hoj\r\n    username: root\r\n    password: hoj123456\r\n  mail:\r\n    ssl: true\r\n    username: your_email_username\r\n    password: your_email_password\r\n    host: smtp.qq.com\r\n    port: 465\r\n    background-img: https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png\r\n  redis:\r\n    host: 127.0.0.1\r\n    port: 6379\r\n    password: hoj123456\r\n  web-config:\r\n    base-url: your_web_url\r\n    name: Hcode Online Judge\r\n    short-name: HOJ\r\n    description: Hcode Online Judge\r\n    register: true\r\n    footer:\r\n      record:\r\n        name: 2020-2021\r\n        url: your_record_url\r\n      project:\r\n        name: HOJ\r\n        url: https://gitee.com/himitzh0730/hoj\r\n  hdu:\r\n    account:\r\n      username: \r\n      password: \r\n  cf:\r\n    account:\r\n      username: \r\n      password: \r\n  poj:\r\n    account:\r\n      username: \r\n      password: \r\n  atcoder:\r\n    account:\r\n      username: \r\n      password: \r\n  spoj:\r\n    account:\r\n      username: \r\n      password: \r\n  switch:\r\n    judge:\r\n      public: true\r\n      group: true\r\n      contest: true\r\n      hide-non-contest-code: false\r\n      submit-interval: 8\r\n    discussion:\r\n      public: true\r\n      group: true\r\n      ac-initial-value: 10\r\n      create-daily: 5\r\n    comment:\r\n      contest: true\r\n      ac-initial-value: 10\r\n    group:\r\n      ac-initial-value: 20\r\n      create-daily: 2\r\n      create-total: 5','42474832652bb8acfc6dac9c705bb1a3','2026-05-13 08:59:24','2026-05-12 19:59:24','nacos','172.20.0.1','U','',''),
(0,2,'hoj-web.yml','DEFAULT_GROUP','','baseUrl: http://127.0.1.1\ndescription: null\nemailBGImg: \'\'\nemailHost: smtp.qq.com\nemailPassword: your_email_password\nemailPort: 465\nemailSsl: true\nemailUsername: your_email_username\nname: FOJ\nprojectName: FOJ\nprojectUrl: \'\'\nrecordName: null\nrecordUrl: null\nregister: true\nshortName: FOJ\n','1bdd01a555a29c5b91c4db5059cce5c3','2026-05-13 08:59:24','2026-05-12 19:59:24','nacos','172.20.0.1','I','',''),
(2,3,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 7d1925ac8ff4481daabc52c1dca2b6a8\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: hoj123456\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','c6a02f46973b804492e727aa8b56ebe3','2026-05-13 09:04:08','2026-05-12 20:04:08','nacos','172.20.0.1','U','',''),
(2,4,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 7d1925ac8ff4481daabc52c1dca2b6a8\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','3f64feb9d53e95883c1f884953a85583','2026-05-13 09:07:33','2026-05-12 20:07:33','nacos','172.20.0.1','U','',''),
(2,5,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 037912196c4041d2a0418085a26f1d1c\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: hoj123456\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','8307ca43c7dd8df758857b997c4d6295','2026-05-13 14:19:05','2026-05-13 01:19:05','nacos','172.20.0.1','U','',''),
(2,6,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 98daaf1e5f584881a24a59a6e6e23fa4\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: hoj123456\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','1cdae66b2b0ebd3e8d5c4c618d81b9a6','2026-05-13 14:20:57','2026-05-13 01:20:57','nacos','172.20.0.1','U','',''),
(2,7,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 7caaac79201b4d528f19b390bb252636\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: hoj123456\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','151752bbef66e46ede618fe063a79400','2026-05-13 14:22:00','2026-05-13 01:22:00','nacos','172.20.0.1','U','',''),
(2,8,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 31f43d78dca4442cabe881f0738e13c7\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','fd459fb58b9958e97b47f04df9323845','2026-05-13 14:31:39','2026-05-13 01:31:39','nacos','172.20.0.1','U','',''),
(1,9,'hoj-prod.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token默认为24小时 86400s\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: hoj-judge-token-init\n  db:\n    host: host.docker.internal\n    public-host: host.docker.internal\n    port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  mail:\n    ssl: true\n    username: your_email_username\n    password: your_email_password\n    host: smtp.qq.com\n    port: 465\n    background-img: https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png\n  redis:\n    host: 172.20.0.2\n    port: 6379\n    password: hoj123456\n  web-config:\n    base-url: your_web_url\n    name: Hcode Online Judge\n    short-name: HOJ\n    description: Hcode Online Judge\n    register: true\n    footer:\n      record:\n        name: 2020-2021\n        url: your_record_url\n      project:\n        name: HOJ\n        url: https://gitee.com/himitzh0730/hoj\n  hdu:\n    account:\n      username: \n      password: \n  cf:\n    account:\n      username: \n      password: \n  poj:\n    account:\n      username: \n      password: \n  atcoder:\n    account:\n      username: \n      password: \n  spoj:\n    account:\n      username: \n      password: \n  switch:\n    judge:\n      public: true\n      group: true\n      contest: true\n      hide-non-contest-code: false\n      submit-interval: 8\n    discussion:\n      public: true\n      group: true\n      ac-initial-value: 10\n      create-daily: 5\n    comment:\n      contest: true\n      ac-initial-value: 10\n    group:\n      ac-initial-value: 20\n      create-daily: 2\n      create-total: 5','1f55c75107ba7af11ccc85128e451143','2026-05-13 14:42:42','2026-05-13 01:42:42','nacos','172.20.0.1','U','',''),
(1,10,'hoj-prod.yml','DEFAULT_GROUP','','hoj:\\n  jwt:\\n    # 加密秘钥\\n    secret: hoj-secret-init\\n    # token默认为24小时 86400s\\n    expire: 86400\\n    checkRefreshExpire: 43200\\n    header: token\\n  judge:\\n    # 调用判题服务器的token\\n    token: hoj-judge-token-init\\n  db:\\n    host: host.docker.internal\\n    public-host: host.docker.internal\\n    port: 3306\\n    name: hoj\\n    username: root\\n    password: xrl15760326784\\n  mail:\\n    ssl: true\\n    username: your_email_username\\n    password: your_email_password\\n    host: smtp.qq.com\\n    port: 465\\n    background-img: https://cdn.jsdelivr.net/gh/HimitZH/CDN/images/HCODE.png\\n  redis:\\n    host: 172.20.0.2\\n    port: 6379\\n    password: hoj123456\\n  web-config:\\n    base-url: your_web_url\\n    name: Hcode Online Judge\\n    short-name: HOJ\\n    description: Hcode Online Judge\\n    register: true\\n    footer:\\n      record:\\n        name: 2020-2021\\n        url: your_record_url\\n      project:\\n        name: HOJ\\n        url: https://gitee.com/himitzh0730/hoj\\n  hdu:\\n    account:\\n      username: \\n      password: \\n  cf:\\n    account:\\n      username: \\n      password: \\n  poj:\\n    account:\\n      username: \\n      password: \\n  atcoder:\\n    account:\\n      username: \\n      password: \\n  spoj:\\n    account:\\n      username: \\n      password: \\n  switch:\\n    judge:\\n      public: true\\n      group: true\\n      contest: true\\n      hide-non-contest-code: false\\n      submit-interval: 8\\n    discussion:\\n      public: true\\n      group: true\\n      ac-initial-value: 10\\n      create-daily: 5\\n    comment:\\n      contest: true\\n      ac-initial-value: 10\\n    group:\\n      ac-initial-value: 20\\n      create-daily: 2\\n      create-total: 5','ed5a2bcdca1a3094cf985826f22de8b8','2026-05-13 14:45:17','2026-05-13 01:45:17','nacos','172.20.0.1','U','',''),
(2,11,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3310cf64594d4382a9573941fce475bf\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: hoj123456\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','26546cfad2eb356b785940a27a501111','2026-05-13 14:47:47','2026-05-13 01:47:47','nacos','172.20.0.1','U','',''),
(2,12,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 624686da338741bc836679c909553ff6\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','5edcd66faa41ead496c58ddad4246505','2026-05-13 14:48:02','2026-05-13 01:48:02','nacos','172.20.0.1','U','',''),
(2,13,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 03dd6ecceb2246f493ee7c961e6fbd9a\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','2e177a7256ef05948d934bf07edfd68b','2026-05-18 15:07:22','2026-05-18 02:07:22','nacos','172.20.0.1','U','',''),
(2,14,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3e2f82ac150f48d78fdceea454f7c0bb\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','4b092ebb7b19c5c38c76ac1b8139b38f','2026-05-19 14:39:57','2026-05-19 01:39:57','nacos','172.20.0.1','U','',''),
(2,15,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 8b264b1f3e514c0ab46dac9dec907133\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','aa78b1b070f3c1ba05d82d3f64ca4634','2026-05-25 14:03:46','2026-05-25 01:03:46','nacos','172.20.0.1','U','',''),
(2,16,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 5b6e19bd3dcb4c9ebd1ea8c8e50c99f8\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: change_me\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','6f7f024bca73c952139414597acd3900','2026-05-25 14:08:49','2026-05-25 01:08:49','nacos','172.20.0.1','U','',''),
(2,17,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 8bd3f8d850ea42d18ea0be5ca1f2da31\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','d49f95388d5a4e91fe166c78664bb08a','2026-05-25 14:59:50','2026-05-25 01:59:50','nacos','172.20.0.1','U','',''),
(2,18,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 728acf2c85c94f60abe3a4f7126ed776\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','189348cc62ff175a60653b62bfae9de8','2026-05-25 15:07:34','2026-05-25 02:07:34','nacos','172.20.0.1','U','',''),
(2,19,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: bb205c23c39d4c588b665a5eb327c24e\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6379\n    password: hoj123456','5d8112f47a81bd01a53865fb6c13fe4e','2026-05-25 15:19:22','2026-05-25 02:19:21','nacos','172.20.0.1','U','',''),
(2,20,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 4ee9b108d7e14071848299bc2510e1b9\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','b5659495d2058113c015094ffd55b2c0','2026-05-25 15:31:24','2026-05-25 02:31:24','nacos','172.20.0.1','U','',''),
(2,21,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 891c75c45bab4f7baf6a62056dca04db\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','b8ec16a211b26a8946800efd94b10ec9','2026-05-26 16:54:58','2026-05-26 03:54:58','nacos','172.20.0.1','U','',''),
(4,22,'hoj-web.yml','DEFAULT_GROUP','','baseUrl: http://127.0.1.1\ndescription: null\nemailBGImg: \'\'\nemailHost: smtp.qq.com\nemailPassword: your_email_password\nemailPort: 465\nemailSsl: true\nemailUsername: your_email_username\nname: FOJ\nprojectName: FOJ\nprojectUrl: \'\'\nrecordName: null\nrecordUrl: null\nregister: true\nshortName: FOJ\n','1bdd01a555a29c5b91c4db5059cce5c3','2026-05-26 17:18:57','2026-05-26 04:18:57','nacos','172.20.0.1','U','',''),
(4,23,'hoj-web.yml','DEFAULT_GROUP','','baseUrl: http://127.0.1.1\ndescription: null\nemailBGImg: \'\'\nemailHost: smtp.163.com\nemailPassword: WAhYwt7TXKTb86s8\nemailPort: 465\nemailSsl: true\nemailUsername: xrlfreedom@163.com\nname: FOJ\nprojectName: FOJ\nprojectUrl: \'\'\nrecordName: null\nrecordUrl: null\nregister: true\nshortName: FOJ\n','0bffd9233ca7d7f7f1f8e08ec340f8f0','2026-05-26 17:20:48','2026-05-26 04:20:48','nacos','172.20.0.1','U','',''),
(2,24,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 7ff4dff9587b4dd8a2bc74c3ee1daaf2\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','c708f48108e517a635109ab7333b49c3','2026-05-26 18:50:47','2026-05-26 05:50:47','nacos','172.20.0.1','U','',''),
(4,25,'hoj-web.yml','DEFAULT_GROUP','','baseUrl: http://127.0.1.1\ndescription: null\nemailBGImg: \'\'\nemailHost: smtp.163.com\nemailPassword: WAhYwt7TXKTb86s8\nemailPort: 465\nemailSsl: true\nemailUsername: xrlfreedom@163.com\nname: FOJ\nprojectName: FOJ\nprojectUrl: \'\'\nrecordName: null\nrecordUrl: null\nregister: true\nshortName: FOJ\n','0bffd9233ca7d7f7f1f8e08ec340f8f0','2026-05-26 18:50:47','2026-05-26 05:50:47','nacos','172.20.0.1','U','',''),
(2,26,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 9d422ff0d2404ef6b835a2098ebda6dd\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','c666771ae2d48d9e45739a09e6642eb6','2026-05-26 21:29:01','2026-05-26 08:29:01','nacos','172.20.0.1','U','',''),
(2,27,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3df601175e4c4e2086c93093f5dbdb5a\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','f4ec6ae50ba04ca989d01d2eddcb4bb0','2026-06-01 17:23:56','2026-06-01 04:23:56','nacos','172.20.0.1','U','',''),
(2,28,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: hoj-secret-init\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: e462c1b484d047f18009ffc9f3a11bec\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','1101246956d7503a3fa10a3ee35091e2','2026-06-01 18:09:16','2026-06-01 05:09:16','nacos','172.20.0.1','U','',''),
(0,29,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 371232d950184f6f8a346ee36bf471a4\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','710c1cdb059b8ba1ea1e39d72678bc78','2026-06-02 00:58:12','2026-06-02 00:58:13',NULL,'192.168.31.187','I','public',''),
(31,30,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 371232d950184f6f8a346ee36bf471a4\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','710c1cdb059b8ba1ea1e39d72678bc78','2026-06-02 01:00:43','2026-06-02 01:00:43',NULL,'192.168.31.187','U','public',''),
(31,31,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: a2495a90faca41519d81300178f47d51\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','b8fbc755945eae5c04548d3aeb1b0f69','2026-06-02 01:06:56','2026-06-02 01:06:57',NULL,'192.168.31.187','U','public',''),
(31,32,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 5ab27c051beb4dfead3e78200a75ca38\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','68b08c6c4e707eda8d1cb9d91f863721','2026-06-02 01:46:31','2026-06-02 01:46:31',NULL,'192.168.31.187','U','public',''),
(31,33,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 374dbee4226945e3873cfd91fb2ab6b3\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','1d67577917436d13cb75de23dce02f59','2026-06-02 01:48:29','2026-06-02 01:48:30',NULL,'192.168.31.187','U','public',''),
(31,34,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 015174e4a8ef4e5495fb577b2541e091\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','d18a5dcf97abfe077e419626bc621957','2026-06-02 14:13:11','2026-06-02 14:13:11',NULL,'100.123.233.122','U','public',''),
(31,35,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3f8e8565a6694870aaafb170afac8cfe\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','7a6a644819c707197771bc536674a9f0','2026-06-02 14:29:38','2026-06-02 14:29:39',NULL,'172.20.10.7','U','public',''),
(31,36,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: foj-smoke-test-secret\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 18294c2cc427462d8af6171bba803652\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','bf2e3bda27d1023ed0c38dc4d966cbe5','2026-06-02 15:11:09','2026-06-02 15:11:10',NULL,'172.20.10.7','U','public',''),
(31,37,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: d23ad0cdbddb41af94a1880f9b8d3552\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','cf131ff2c09aded2734bb3fdc01df7b1','2026-06-02 15:18:23','2026-06-02 15:18:24',NULL,'172.20.10.7','U','public',''),
(31,38,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: b5b628eb98cd4ea49f36fe0545b965bd\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','7dc8d5b33e1451cd8f41039f44cb53a4','2026-06-02 15:21:00','2026-06-02 15:21:01',NULL,'172.20.10.7','U','public',''),
(31,39,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: aaf27bd960a0466a8cd0c550e052164b\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','718fb27a79bf14328cad106799f9ee33','2026-06-02 15:51:24','2026-06-02 15:51:24',NULL,'172.20.10.7','U','public',''),
(31,40,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 2458e7efde7d4ce3aaee039bc2912730\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','b345aaff2bd9689339e1f1176d2cfd98','2026-06-02 16:11:05','2026-06-02 16:11:06',NULL,'172.20.10.7','U','public',''),
(31,41,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: a48ab03af62543b481f93f34de785912\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','304a6c72c7ea3009206c6b0dd1bf6d06','2026-06-02 16:32:35','2026-06-02 16:32:36',NULL,'172.20.10.7','U','public',''),
(31,42,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 64351be273fd47d19659aa543b03a3fd\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','3e9252450def6a2a69550901614a6954','2026-06-02 17:05:12','2026-06-02 17:05:13',NULL,'172.20.10.7','U','public',''),
(31,43,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 7515f72c528c4dd8bdb4ee521ad4fb6a\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','71246579841a1687c6d0899d0397633f','2026-06-02 17:13:30','2026-06-02 17:13:31',NULL,'172.20.10.7','U','public',''),
(31,44,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: c8451a02aea44912b9b2245a0b791881\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','dce2461cbed7f91e6ce25954eceac041','2026-06-02 17:19:56','2026-06-02 17:19:56',NULL,'172.20.10.7','U','public',''),
(31,45,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3b430b02c8df43429faf01328bbb6230\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','ccd778601088b1e36d08804f23f99023','2026-06-02 17:25:28','2026-06-02 17:25:29',NULL,'172.20.10.7','U','public',''),
(31,46,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 832cd0b7a62141798c375abda0041ec6\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','9d2a0d9ea8742db2f3042426ed331379','2026-06-02 17:55:29','2026-06-02 17:55:29',NULL,'192.168.31.187','U','public',''),
(31,47,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: cd51d9d75f2e49c4b216108ebaade12e\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','4557f0323ad659d349b5bfb9ae598eef','2026-06-02 23:46:22','2026-06-02 23:46:22',NULL,'192.168.31.187','U','public',''),
(31,48,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: f7678770c7a6493a9c410d0b806cab67\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','698e8f7ef5a6d02dc310f9f00dd1399a','2026-06-03 00:05:55','2026-06-03 00:05:56',NULL,'192.168.31.187','U','public',''),
(31,49,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: b4d1b231111b4b2abdd0278207423328\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','f88595dc935ee7aaea9799fc2a0b8a77','2026-06-03 00:37:19','2026-06-03 00:37:20',NULL,'192.168.31.187','U','public',''),
(31,50,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: d7c5c964cf764ab9b94261183a11a180\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','0fdf5e62fae407b598d4072ca3a0ce48','2026-06-03 01:02:46','2026-06-03 01:02:46',NULL,'192.168.31.187','U','public',''),
(31,51,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: c676002ada684a698404b324e601e0ae\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','a7457f40bfe84415ad3283f5c2e34d5a','2026-06-03 01:08:06','2026-06-03 01:08:06',NULL,'192.168.31.187','U','public',''),
(31,52,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: e1d53b8994ac4a56aabebdf6a690919b\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','cbe1724b56174647252bb0d484ece924','2026-06-03 01:11:11','2026-06-03 01:11:12',NULL,'192.168.31.187','U','public',''),
(31,53,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 90594153ee2e43559267aa476e94800e\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','58d1b1f9c8b08c942dd413578ad2632b','2026-06-03 01:16:07','2026-06-03 01:16:08',NULL,'192.168.31.187','U','public',''),
(31,54,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 08943f1a74814873a0dab3fbf18574f1\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','9c17d2643f24d24d59836a07dc7542a8','2026-06-03 01:29:06','2026-06-03 01:29:07',NULL,'192.168.31.187','U','public',''),
(31,55,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 8e2353b9ec694bfaa687eb2d52517ea2\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','3bc28b2c709aa2c2ab638facfd99b5b0','2026-06-03 13:51:11','2026-06-03 13:51:12',NULL,'192.168.31.187','U','public',''),
(31,56,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: d156b7d08f6648e1b899c83842876743\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','41ac6cde85e4f445848e2fdebee06456','2026-06-03 14:26:16','2026-06-03 14:26:17',NULL,'192.168.31.187','U','public',''),
(31,57,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 96c14b57e3ae4ed2b1f632bb1edabed2\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','c26b1ebe5cd8989f9320f2c73fc0debd','2026-06-03 14:53:26','2026-06-03 14:53:26',NULL,'192.168.31.187','U','public',''),
(31,58,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 9a2cd86991db4f10a7a6dfe95bd1ba2e\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','322dfd22061ce901d018ae366ad52596','2026-06-03 14:54:40','2026-06-03 14:54:40',NULL,'192.168.31.187','U','public',''),
(31,59,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: cab1bf36cf8145459ee117a99a777373\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','a79c7f21eeb05dfcbfcc93a74690e8c7','2026-06-03 14:57:42','2026-06-03 14:57:43',NULL,'192.168.31.187','U','public',''),
(31,60,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 3d2dc348a49d429baa96e0f3b81e877b\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','315eaad2704a9843e425a1973c7a778b','2026-06-03 15:03:20','2026-06-03 15:03:21',NULL,'192.168.31.187','U','public',''),
(31,61,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 843dab119b6b4636a484ffc642428d8a\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','536b63b13c0e1783f5164bd0424f5648','2026-06-03 15:08:28','2026-06-03 15:08:28',NULL,'192.168.31.187','U','public',''),
(31,62,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: dcdcabbcc19c4a89901f15673607e761\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','4e81b6e0ccec3cd3a46a2501cfce998d','2026-06-03 15:21:43','2026-06-03 15:21:44',NULL,'192.168.31.187','U','public',''),
(31,63,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 72318b836aac48e08e04965da1e13f56\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','3f22b33369c3920e3ca63760c6797355','2026-06-03 15:42:10','2026-06-03 15:42:11',NULL,'192.168.31.187','U','public',''),
(31,64,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: bf2758d321124941936c021772fdfcaa\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','08f98241317a72e175cee236b5764a1f','2026-06-03 15:48:13','2026-06-03 15:48:13',NULL,'192.168.31.187','U','public',''),
(31,65,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 8031668502db4e6e9a6b9c92b9c5f110\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','92b3008a33d9b9ea6f64dae856d8c44f','2026-06-03 15:58:17','2026-06-03 15:58:18',NULL,'192.168.31.187','U','public',''),
(31,66,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: ab4b9903a8f144de8be83e350b3b7121\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','58a02dd008a6493d28a1da40f2b5604b','2026-06-03 16:05:20','2026-06-03 16:05:21',NULL,'192.168.31.187','U','public',''),
(31,67,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 6903a19e025045b39db03265fe23f235\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','fd9d0354f2c48866c10a1d867a17c0c9','2026-06-03 16:14:46','2026-06-03 16:14:47',NULL,'192.168.31.187','U','public',''),
(31,68,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 47f9d1bfd70348edbfb6c3713742c827\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','63a7a2152f96276e1a836913f2c8065a','2026-06-03 17:41:21','2026-06-03 17:41:22',NULL,'192.168.31.187','U','public',''),
(31,69,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 626c8f3adf01470b909ec15743abb077\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','546cea2c72130b937a92600755e01613','2026-06-03 17:46:23','2026-06-03 17:46:23',NULL,'192.168.31.187','U','public',''),
(31,70,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 9af3483409ff423c8305be24030dae39\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','fd8385a09d95a4eaf1a68437d553baae','2026-06-03 17:49:24','2026-06-03 17:49:25',NULL,'192.168.31.187','U','public',''),
(31,71,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 1da89630b2624bf9854813e4d990c97a\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','54c4fb3650943e3bfceb919965a34b6a','2026-06-03 17:53:30','2026-06-03 17:53:31',NULL,'192.168.31.187','U','public',''),
(31,72,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 68db0121160f4545a2a7801fecf143aa\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','73207f9563c95aa2510435b945aebd4f','2026-06-03 17:57:13','2026-06-03 17:57:14',NULL,'192.168.31.187','U','public',''),
(31,73,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 9b037190ec464fff84d241daa78ed331\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','7d96ffd19d7ceae5089b5237b7714974','2026-06-03 18:29:25','2026-06-03 18:29:25',NULL,'192.168.31.187','U','public',''),
(31,74,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 25189c5e3ef840a3ae217df62ea7ad68\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','14833450f63d2a74405ab615382d30c3','2026-06-03 18:36:21','2026-06-03 18:36:22',NULL,'192.168.31.187','U','public',''),
(31,75,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: da869ca894ac422c9ee6ddee7ce4321f\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','8c6b6ae8f708e54932c514ee4f532b3f','2026-06-03 21:28:05','2026-06-03 21:28:06',NULL,'192.168.31.187','U','public',''),
(31,76,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: e6da2d30519c4710bc32e62cc1ce1788\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','0ef97e83c0163ce76d1d3e7570d893da','2026-06-03 21:54:10','2026-06-03 21:54:11',NULL,'192.168.31.187','U','public',''),
(31,77,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 20daea5c862d4a11a4e21e90d5d745df\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','914dafd1e3e34061ae5ccec0577b701f','2026-06-03 22:52:19','2026-06-03 22:52:19',NULL,'192.168.31.187','U','public',''),
(31,78,'hoj-dev.yml','DEFAULT_GROUP','','hoj:\n  jwt:\n    # 加密秘钥\n    secret: default\n    # token有效时长，1天，单位秒\n    expire: 86400\n    checkRefreshExpire: 43200\n    header: token\n  judge:\n    # 调用判题服务器的token\n    token: 94dcfac9813549cf802b8199be77fa31\n  db:\n    host: 127.0.0.1\n    port: 3306\n    public-host: 127.0.0.1\n    public-port: 3306\n    name: hoj\n    username: root\n    password: xrl15760326784\n  redis:\n    host: 127.0.0.1\n    port: 6380\n    password: hoj123456','7b1510eade70286ade12672967742a09','2026-06-03 23:27:10','2026-06-03 23:27:11',NULL,'192.168.31.187','U','public','');
/*!40000 ALTER TABLE `his_config_info` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `role` varchar(50) NOT NULL,
  `resource` varchar(255) NOT NULL,
  `action` varchar(8) NOT NULL,
  UNIQUE KEY `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `username` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  UNIQUE KEY `idx_user_role` (`username`,`role`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
('nacos','ROLE_ADMIN');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `tenant_capacity`
--

DROP TABLE IF EXISTS `tenant_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_capacity` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) COLLATE utf8mb3_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  `max_aggr_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='租户容量信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_capacity`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tenant_capacity` WRITE;
/*!40000 ALTER TABLE `tenant_capacity` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenant_capacity` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `tenant_info`
--

DROP TABLE IF EXISTS `tenant_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) COLLATE utf8mb3_bin NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) COLLATE utf8mb3_bin DEFAULT '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='tenant_info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_info`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tenant_info` WRITE;
/*!40000 ALTER TABLE `tenant_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenant_info` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `password` varchar(500) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('nacos','$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping events for database 'nacos'
--

--
-- Dumping routines for database 'nacos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-06-04  2:12:01
