create schema if not exists "ABITURA";

--drop table "ABITURA"."SUPER_DIFF";
create table if not exists "ABITURA"."SUPER_DIFF"
(
    "ID"            serial primary key,
    "CREATED"       timestamp default current_timestamp not null,
    "TG_OP"         varchar(6)                          not null,
    "TG_TABLE_NAME" varchar(100)                        not null,
    "UUID"          varchar(30)                         not null
);

drop function "ABITURA".make_diff cascade;
create function "ABITURA".make_diff() returns trigger as
$$
declare
    l_uuid varchar(30);
begin
    if tg_op = 'DELETE' then
        l_uuid := old."UUID";
    else
        l_uuid := new."UUID";
    end if;
    insert into "ABITURA"."SUPER_DIFF" ("TG_OP", "TG_TABLE_NAME", "UUID")
    values (tg_op, tg_table_name, l_uuid);
    return new;
end;
$$ language plpgsql;

create table if not exists "ABITURA"."SUPER_KAF"
(
    "UUID" varchar(30) primary key,
    "NAME" varchar(500) not null
);
--drop trigger diff on "ABITURA"."SUPER_KAF";
create trigger diff
    after insert or update or delete
    on "ABITURA"."SUPER_KAF"
    for each row
execute procedure "ABITURA".make_diff();
