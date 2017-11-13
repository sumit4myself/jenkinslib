DROP TABLE IF EXISTS `avs_version`;

CREATE TABLE `avs_version` (
  `creation_date` datetime NOT NULL DEFAULT '2017-09-14 14:00:00' ,
  `update_date` datetime NOT NULL DEFAULT '2017-09-14 14:00:00',
  `avs_release` varchar(10) NOT NULL,
  `avs_last_incremental` int(11) NOT NULL DEFAULT '0',
  `avs_start_incremental` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`avs_release`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `SOFTWARE`;


CREATE TABLE SOFTWARE(creation_date DATETIME DEFAULT NOW(), 
id BIGINT(11) PRIMARY KEY AUTO_INCREMENT,
sw_version VARCHAR(30),
session_prefix VARCHAR(50),
is_target_groupId TINYINT(1),
targetId VARCHAR(1000),
signed TINYINT(1),
encrypted TINYINT(1),
status TINYINT(1),
distributed_via_mmddf TINYINT(1),
multicast_ipaddress VARCHAR(20),
multicast_port INT(5),
multicast_bw INT(4),
priority INT(4),
description VARCHAR(500),
starttime Long,
filename VARCHAR(256),
unicast_url VARCHAR(256),
upgrade_count INT(11),
last_updated_datetime Long,
last_updated_username VARCHAR(30)
);

DROP TABLE IF EXISTS `SOFTWARE_AUDIT`;

CREATE TABLE SOFTWARE_AUDIT(creation_date DATETIME,
sw_audit_id BIGINT(11) PRIMARY KEY AUTO_INCREMENT,
id BIGINT(11),
sw_version VARCHAR(30),
session_prefix VARCHAR(50),
is_target_groupId TINYINT(1),
targetId VARCHAR(1000),
signed TINYINT(1),
encrypted TINYINT(1),
status TINYINT(1),
distributed_via_mmddf TINYINT(1),
multicast_ipaddress VARCHAR(20),
multicast_port INT(5),
multicast_bw INT(4),
priority INT(4),
description VARCHAR(500),
starttime BIGINT(11),
filename VARCHAR(256),
unicast_url VARCHAR(256),
upgrade_count INT,
last_updated_datetime Long,
last_updated_username VARCHAR(30),
audit_action VARCHAR(30)
);