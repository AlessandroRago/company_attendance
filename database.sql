-- we don't know how to generate root <with-no-name> (class Root) :(

grant alter, alter routine, create, create routine, create tablespace, create temporary tables, create user, create view, delete, delete history, drop, event, execute, file, index, insert, lock tables, process, references, reload, replication client, replication slave, select, show databases, show view, shutdown, super, trigger, update, grant option on *.* to root@'127.0.0.1';

grant alter, alter routine, create, create routine, create tablespace, create temporary tables, create user, create view, delete, delete history, drop, event, execute, file, index, insert, lock tables, process, references, reload, replication client, replication slave, select, show databases, show view, shutdown, super, trigger, update, grant option on *.* to root@'::1';

grant alter, alter routine, create, create routine, create tablespace, create temporary tables, create user, create view, delete, delete history, drop, event, execute, file, index, insert, lock tables, process, references, reload, replication client, replication slave, select, show databases, show view, shutdown, super, trigger, update, grant option on *.* to root@localhost;

create table justifications
(
    id          int auto_increment
        primary key,
    description varchar(100) null
);

create table user
(
    id       int auto_increment
        primary key,
    name     varchar(100) null,
    surname  varchar(100) null,
    password varchar(100) null
);

create table entrance
(
    id      int auto_increment
        primary key,
    date    datetime null,
    user_id int      null,
    constraint entrance___fk
        foreign key (user_id) references user (id)
);

create table `exit`
(
    id               int auto_increment
        primary key,
    date             datetime null,
    user_id          int      null,
    justification_id int      null,
    constraint justification_id
        foreign key (justification_id) references justifications (id),
    constraint user_id
        foreign key (user_id) references user (id)
);

