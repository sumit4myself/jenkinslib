call drop_column_if_exists ('software_upgrade', 'software', 'is_target_groupId');
call drop_column_if_exists ('software_upgrade', 'software_audit', 'is_target_groupId');
alter table software add column target_type_id TINYINT(1) after session_prefix;
alter table software_audit add column target_type_id TINYINT(1) after session_prefix;
alter table software modify starttime BIGINT(11);
alter table software modify last_updated_datetime BIGINT(11);
alter table software_audit modify last_updated_datetime BIGINT(11);