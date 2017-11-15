call drop_column_if_exists ('software_upgrade', 'software', 'target_type_id');
call drop_column_if_exists ('software_upgrade', 'software_audit', 'target_type_id');
alter table software add column is_target_groupId TINYINT(1) after session_prefix;
alter table software_audit add column is_target_groupId TINYINT(1) after session_prefix;
alter table software modify starttime Long;
alter table software modify last_updated_datetime Long;
alter table software_audit modify last_updated_datetime Long;
