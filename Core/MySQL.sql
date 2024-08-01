# phpMyAdmin SQL Dump
# version 2.5.6-rc1
# http://www.phpmyadmin.net
#
# Host: localhost
# Generation Time: Mar 06, 2004 at 11:59 AM
# Server version: 4.0.15
# PHP Version: 4.2.3
# 
# Database : `FusionSQL`
# 

# --------------------------------------------------------

#
# Table structure for table `account_flags`
#

DROP TABLE IF EXISTS `account_flags`;
CREATE TABLE `account_flags` (
  `GID` bigint(10) NOT NULL default '0',
  `flagdata` longtext NOT NULL,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `accounts`
#

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `AID` bigint(10) unsigned NOT NULL auto_increment,
  `ID` varchar(24) NOT NULL default '',
  `passwd` varchar(24) NOT NULL default '',
  `Gender` tinyint(2) NOT NULL default '1',
  `Mail` varchar(50) NOT NULL default '-@-',
  `Banned` tinyint(2) NOT NULL default '0',
  `regDate` datetime default NULL,
  PRIMARY KEY  (`AID`),
  KEY `ID` (`ID`)
) TYPE=MyISAM AUTO_INCREMENT=100492 ;

# --------------------------------------------------------

#
# Table structure for table `cart`
#

DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `GID` bigint(10) unsigned NOT NULL default '0',
  `cartitem` longtext,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `character_flags`
#

DROP TABLE IF EXISTS `character_flags`;
CREATE TABLE `character_flags` (
  `GID` bigint(10) NOT NULL default '0',
  `flagdata` longtext NOT NULL,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `characters`
#

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `GID` bigint(10) unsigned NOT NULL auto_increment,
  `Name` varchar(24) NOT NULL default '',
  `JID` int(4) default NULL,
  `BaseLV` int(4) unsigned default NULL,
  `BaseEXP` bigint(10) unsigned default NULL,
  `StatusPoint` int(4) unsigned default NULL,
  `JobLV` int(4) unsigned default NULL,
  `JobEXP` bigint(10) unsigned default NULL,
  `SkillPoint` int(4) unsigned default NULL,
  `Zeny` bigint(10) unsigned default NULL,
  `Stat1` int(4) default NULL,
  `Stat2` int(4) default NULL,
  `Options` int(4) default NULL,
  `Karma` int(4) default NULL,
  `Manner` int(4) default NULL,
  `HP` int(4) unsigned default NULL,
  `SP` int(4) unsigned default NULL,
  `DefaultSpeed` smallint(2) default NULL,
  `Hair` smallint(2) default NULL,
  `_2` smallint(2) default NULL,
  `_3` smallint(2) default NULL,
  `Weapon` smallint(2) default NULL,
  `Shield` smallint(2) default NULL,
  `Head1` smallint(2) default NULL,
  `Head2` smallint(2) default NULL,
  `Head3` smallint(2) default NULL,
  `HairColor` smallint(2) default NULL,
  `ClothesColor` smallint(2) default NULL,
  `STR` smallint(2) default NULL,
  `AGI` smallint(2) default NULL,
  `VIT` smallint(2) default NULL,
  `INTS` smallint(2) default NULL,
  `DEX` smallint(2) default NULL,
  `LUK` smallint(2) default NULL,
  `CharaNumber` smallint(2) default NULL,
  `Map` varchar(24) default NULL,
  `X` smallint(2) default NULL,
  `Y` smallint(2) default NULL,
  `SaveMap` varchar(24) default NULL,
  `SX` smallint(2) default NULL,
  `SY` smallint(2) default NULL,
  `Plag` smallint(2) default NULL,
  `PLv` smallint(2) default NULL,
  `AID` bigint(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`GID`),
  KEY `AID` (`AID`)
) TYPE=MyISAM AUTO_INCREMENT=101242 ;

# --------------------------------------------------------

#
# Table structure for table `guild_allies`
#

DROP TABLE IF EXISTS `guild_allies`;
CREATE TABLE `guild_allies` (
  `GDID` bigint(10) unsigned NOT NULL default '0',
  `GuildName` varchar(24) default NULL,
  `Relation` smallint(2) default NULL,
  UNIQUE KEY `GDID` (`GDID`),
  KEY `mutidata` (`GDID`,`GuildName`,`Relation`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `guild_banish`
#

DROP TABLE IF EXISTS `guild_banish`;
CREATE TABLE `guild_banish` (
  `GDID` bigint(10) unsigned NOT NULL default '0',
  `MemberName` varchar(24) default NULL,
  `MemberAccount` varchar(24) default NULL,
  `Reason` varchar(50) default NULL
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `guild_castle`
#

DROP TABLE IF EXISTS `guild_castle`;
CREATE TABLE `guild_castle` (
  `Name` varchar(24) NOT NULL default '',
  `GDID` bigint(10) unsigned default NULL,
  `GName` varchar(24) default NULL,
  `GMName` varchar(24) default NULL,
  `GKafra` int(4) default NULL,
  `EDegree` int(4) default NULL,
  `ETrigger` int(4) default NULL,
  `DDegree` int(4) default NULL,
  `DTrigger` int(4) default NULL,
  `GuardStatus0` int(4) default NULL,
  `GuardStatus1` int(4) default NULL,
  `GuardStatus2` int(4) default NULL,
  `GuardStatus3` int(4) default NULL,
  `GuardStatus4` int(4) default NULL,
  `GuardStatus5` int(4) default NULL,
  `GuardStatus6` int(4) default NULL,
  `GuardStatus7` int(4) default NULL,
  UNIQUE KEY `Name` (`Name`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `guild_info`
#

DROP TABLE IF EXISTS `guild_info`;
CREATE TABLE `guild_info` (
  `GDID` bigint(10) unsigned NOT NULL auto_increment,
  `Name` varchar(24) NOT NULL default '',
  `LV` int(4) unsigned default NULL,
  `EXP` bigint(10) unsigned default NULL,
  `GSkillPoint` int(4) unsigned default NULL,
  `Subject` varchar(60) default NULL,
  `Notice` varchar(120) default NULL,
  `Agit` varchar(24) default NULL,
  `Emblem` int(4) unsigned default NULL,
  `present` bigint(10) unsigned default NULL,
  `DisposFV` int(4) default NULL,
  `DisposRW` int(4) default NULL,
  `skill` longtext,
  PRIMARY KEY  (`GDID`)
) TYPE=MyISAM AUTO_INCREMENT=5 ;

# --------------------------------------------------------

#
# Table structure for table `guild_members`
#

DROP TABLE IF EXISTS `guild_members`;
CREATE TABLE `guild_members` (
  `GDID` bigint(10) unsigned NOT NULL default '0',
  `GID` bigint(10) unsigned default NULL,
  `PositionID` int(4) unsigned default NULL,
  `MemberExp` bigint(10) unsigned default NULL,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `guild_positions`
#

DROP TABLE IF EXISTS `guild_positions`;
CREATE TABLE `guild_positions` (
  `GDID` bigint(10) unsigned NOT NULL default '0',
  `Grade` int(4) default NULL,
  `PosName` varchar(24) default NULL,
  `PosInvite` smallint(2) default NULL,
  `PosPunish` smallint(2) default NULL,
  `PosEXP` bigint(10) unsigned default NULL,
  KEY `GDID` (`GDID`),
  KEY `mutidata` (`GDID`,`Grade`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `inventory`
#

DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory` (
  `GID` bigint(10) unsigned NOT NULL default '0',
  `equipItem` longtext,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `party`
#

DROP TABLE IF EXISTS `party`;
CREATE TABLE `party` (
  `GRID` bigint(10) unsigned NOT NULL auto_increment,
  `Name` varchar(24) NOT NULL default '',
  `EXPShare` smallint(2) NOT NULL default '0',
  `ITEMShare` smallint(2) NOT NULL default '0',
  `MemberID0` bigint(10) unsigned default NULL,
  `MemberID1` bigint(10) unsigned default NULL,
  `MemberID2` bigint(10) unsigned default NULL,
  `MemberID3` bigint(10) unsigned default NULL,
  `MemberID4` bigint(10) unsigned default NULL,
  `MemberID5` bigint(10) unsigned default NULL,
  `MemberID6` bigint(10) unsigned default NULL,
  `MemberID7` bigint(10) unsigned default NULL,
  `MemberID8` bigint(10) unsigned default NULL,
  `MemberID9` bigint(10) unsigned default NULL,
  `MemberID10` bigint(10) unsigned default NULL,
  `MemberID11` bigint(10) unsigned default NULL,
  UNIQUE KEY `Name` (`Name`),
  KEY `GRID` (`GRID`)
) TYPE=MyISAM AUTO_INCREMENT=53 ;

# --------------------------------------------------------

#
# Table structure for table `pet`
#

DROP TABLE IF EXISTS `pet`;
CREATE TABLE `pet` (
  `PID` bigint(10) unsigned NOT NULL auto_increment,
  `PlayerID` bigint(10) unsigned default NULL,
  `CharaID` bigint(10) unsigned default NULL,
  `Cart` int(4) default NULL,
  `PIndex` int(4) default NULL,
  `Incubated` smallint(2) default NULL,
  `JID` int(4) default NULL,
  `Name` varchar(24) default NULL,
  `Renamed` smallint(2) default NULL,
  `LV` int(4) unsigned default NULL,
  `Relation` int(4) default NULL,
  `Fullness` int(4) default NULL,
  `Accessory` int(4) unsigned default NULL,
  PRIMARY KEY  (`PID`)
) TYPE=MyISAM AUTO_INCREMENT=11 ;

# --------------------------------------------------------

#
# Table structure for table `server_flags`
#

DROP TABLE IF EXISTS `server_flags`;
CREATE TABLE `server_flags` (
  `GID` bigint(10) NOT NULL default '0',
  `flagdata` longtext NOT NULL,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `skills`
#

DROP TABLE IF EXISTS `skills`;
CREATE TABLE `skills` (
  `GID` bigint(10) unsigned NOT NULL default '0',
  `skillInfo` longtext,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `storage`
#

DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage` (
  `AID` bigint(10) unsigned NOT NULL default '0',
  `storeitem` longtext,
  `money` int(4) unsigned NOT NULL default '0',
  UNIQUE KEY `AID` (`AID`)
) TYPE=MyISAM;

# --------------------------------------------------------

#
# Table structure for table `warpmemo`
#

DROP TABLE IF EXISTS `warpmemo`;
CREATE TABLE `warpmemo` (
  `GID` bigint(10) unsigned NOT NULL default '0',
  `mapName0` varchar(24) default NULL,
  `xPos0` smallint(2) default NULL,
  `yPos0` smallint(2) default NULL,
  `mapName1` varchar(24) default NULL,
  `xPos1` smallint(2) default NULL,
  `yPos1` smallint(2) default NULL,
  `mapName2` varchar(24) default NULL,
  `xPos2` smallint(2) default NULL,
  `yPos2` smallint(2) default NULL,
  UNIQUE KEY `GID` (`GID`)
) TYPE=MyISAM;