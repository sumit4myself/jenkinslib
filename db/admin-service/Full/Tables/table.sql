DROP TABLE IF EXISTS version;

CREATE TABLE version (
  build_nember varchar,
  creation_date timestamp without time zone NOT NULL DEFAULT now(),
  update_date timestamp without time zone NOT NULL DEFAULT now(),
  last_incremental integer NOT NULL DEFAULT 0,
  start_incremental integer NOT NULL DEFAULT 0
);
