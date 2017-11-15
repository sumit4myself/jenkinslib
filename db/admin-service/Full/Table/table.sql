DROP TABLE IF EXISTS version;

CREATE TABLE version (
  id integer not null PRIMARY KEY,
  creation_date datetime NOT NULL NOW() ,
  update_date datetime NOT NULL NOW(),
  avs_last_incremental int(11) NOT NULL DEFAULT 0,
  avs_start_incremental int(11) NOT NULL DEFAULT 0,
);
