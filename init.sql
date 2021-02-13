create schema if not exists "ABITURA";

create table if not exists "ABITURA"."SUPER_DIFF" (
  --id pk
  --created now
  --uuid
  "ACTION" varchar(30),
  "TABLE_NAME" varchar(500) not null
);

CREATE FUNCTION "ABITURA".make_diff() RETURNS trigger AS $$
  -- DECLARE
  --  action varchar(30);
  BEGIN
    insert into "ABITURA"."SUPER_DIFF" ("ACTION", "TABLE_NAME") values (TG_OP, TG_TABLE_NAME);
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

create table if not exists "ABITURA"."SUPER_KAF" (
  "KAF" varchar(30) primary key,
  "NAME" varchar(500) not null
);
CREATE TRIGGER diff AFTER INSERT OR UPDATE OR DELETE ON "ABITURA"."SUPER_KAF"
  FOR EACH ROW EXECUTE PROCEDURE "ABITURA".make_diff();

insert into "ABITURA"."SUPER_KAF" (
    "KAF",
    "NAME")
values ('123', 'dfdfdf');
