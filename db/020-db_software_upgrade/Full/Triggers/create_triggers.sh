#!/bin/sh
mysql -uroot -p$2 -h$4 --port=$3 <<EOF

USE $1;

DROP TRIGGER IF EXISTS avs_version_insert;
CREATE TRIGGER avs_version_insert  
BEFORE INSERT ON avs_version  
FOR EACH ROW SET NEW.CREATION_DATE =  NOW(),
NEW.UPDATE_DATE =  NOW();

DROP TRIGGER IF EXISTS avs_version_update;
CREATE TRIGGER avs_version_update 
BEFORE UPDATE ON avs_version 
FOR EACH ROW SET NEW.update_date =  NOW() ;

DROP TRIGGER IF EXISTS software_audit_insert;

CREATE TRIGGER software_audit_insert  
AFTER INSERT ON SOFTWARE  
FOR EACH ROW INSERT INTO SOFTWARE_AUDIT(
creation_date,
id,
sw_version,
session_prefix,
target_type_id,
targetId,
signed,
encrypted,
status,
distributed_via_mmddf,
multicast_ipaddress,
multicast_port,
multicast_bw,
priority,
description,
starttime,
filename,
unicast_url,
upgrade_count,
last_updated_datetime,
last_updated_username,
audit_action)
VALUES (NEW.creation_date,
NEW.id,
NEW.sw_version,
NEW.session_prefix,
NEW.target_type_id,
NEW.targetId,
NEW.signed,
NEW.encrypted,
NEW.status,
NEW.distributed_via_mmddf,
NEW.multicast_ipaddress,
NEW.multicast_port,
NEW.multicast_bw,
NEW.priority,
NEW.description,
NEW.starttime,
NEW.filename,
NEW.unicast_url,
NEW.upgrade_count,
NEW.last_updated_datetime,
NEW.last_updated_username,
'INSERT');


DROP TRIGGER IF EXISTS software_audit_update;

CREATE TRIGGER software_audit_update  
AFTER UPDATE ON SOFTWARE  
FOR EACH ROW INSERT INTO SOFTWARE_AUDIT(
creation_date,
id,
sw_version,
session_prefix,
target_type_id,
targetId,
signed,
encrypted,
status,
distributed_via_mmddf,
multicast_ipaddress,
multicast_port,
multicast_bw,
priority,
description,
starttime,
filename,
unicast_url,
upgrade_count,
last_updated_datetime,
last_updated_username,
audit_action)
VALUES (OLD.creation_date,
OLD.id,
OLD.sw_version,
OLD.session_prefix,
OLD.target_type_id,
OLD.targetId,
OLD.signed,
OLD.encrypted,
OLD.status,
OLD.distributed_via_mmddf,
OLD.multicast_ipaddress,
OLD.multicast_port,
OLD.multicast_bw,
OLD.priority,
OLD.description,
OLD.starttime,
OLD.filename,
OLD.unicast_url,
OLD.upgrade_count,
OLD.last_updated_datetime,
OLD.last_updated_username,
'UPDATE');

DROP TRIGGER IF EXISTS software_audit_delete;

CREATE TRIGGER software_audit_delete  
AFTER DELETE ON SOFTWARE  
FOR EACH ROW INSERT INTO SOFTWARE_AUDIT(
create_date,
id,
sw_version,
session_prefix,
target_type_id,
targetId,
signed,
encrypted,
status,
distributed_via_mmddf,
multicast_ipaddress,
multicast_port,
multicast_bw,
priority,
description,
starttime,
filename,
unicast_url,
upgrade_count,
last_updated_datetime,
last_updated_username,
audit_action)
VALUES (OLD.creation_date,
OLD.id,
OLD.sw_version,
OLD.session_prefix,
OLD.target_type_id,
OLD.targetId,
OLD.signed,
OLD.encrypted,
OLD.status,
OLD.distributed_via_mmddf,
OLD.multicast_ipaddress,
OLD.multicast_port,
OLD.multicast_bw,
OLD.priority,
OLD.description,
OLD.starttime,
OLD.filename,
OLD.unicast_url,
OLD.upgrade_count,
OLD.last_updated_datetime,
OLD.last_updated_username,
'DELETE');

EOF
