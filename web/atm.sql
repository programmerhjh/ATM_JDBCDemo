/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50627
Source Host           : localhost:3306
Source Database       : atm

Target Server Type    : MYSQL
Target Server Version : 50627
File Encoding         : 65001

Date: 2018-03-16 18:07:12
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `bankacount`
-- ----------------------------
DROP TABLE IF EXISTS `bankacount`;
CREATE TABLE `bankacount` (
  `bid` bigint(20) NOT NULL,
  `uid` bigint(20) NOT NULL,
  `balance` double DEFAULT NULL,
  PRIMARY KEY (`bid`),
  KEY `uid_idx` (`uid`),
  CONSTRAINT `uid` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bankacount
-- ----------------------------
INSERT INTO `bankacount` VALUES ('21131231', '123123211321', '4123456');
INSERT INTO `bankacount` VALUES ('21312311', '123213121321', '18823456');
INSERT INTO `bankacount` VALUES ('23131231', '112321321321', '41234516');
INSERT INTO `bankacount` VALUES ('2131343231', '121321321', '120');
INSERT INTO `bankacount` VALUES ('12321321123', '12321321', '40');
INSERT INTO `bankacount` VALUES ('21312796731', '12323211321', '1211221');
INSERT INTO `bankacount` VALUES ('21365761231', '1232321321', '41234526');
INSERT INTO `bankacount` VALUES ('213112312231', '121332121321', '41234561');
INSERT INTO `bankacount` VALUES ('213145764231', '12323232111321', '33333');
INSERT INTO `bankacount` VALUES ('213154856231', '12322131321', '21212');
INSERT INTO `bankacount` VALUES ('213167867231', '12334421321', '41234');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uid` bigint(20) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('12321321', 'tom', '123456');
INSERT INTO `user` VALUES ('121321321', 'wss', '123456');
INSERT INTO `user` VALUES ('1232321321', 'qq', '123456');
INSERT INTO `user` VALUES ('12322131321', 'sssss', '123456');
INSERT INTO `user` VALUES ('12323211321', 'aaaa', '123456');
INSERT INTO `user` VALUES ('12334421321', 'aa', '123456');
INSERT INTO `user` VALUES ('112321321321', 'ee', '123456');
INSERT INTO `user` VALUES ('121332121321', 'jj', '123456');
INSERT INTO `user` VALUES ('123123211321', 'aaa', '123456');
INSERT INTO `user` VALUES ('123213121321', 'ss', '123456');
INSERT INTO `user` VALUES ('123213213121', 'ann', '123456');
INSERT INTO `user` VALUES ('12323232111321', 'tssom', '123456');
