create sequence IF NOT EXISTS hibernate_sequence start with 1 increment by 1;

create table IF NOT EXISTS Fruit (
       id bigint not null,
        name varchar(40),
        primary key (id)
);
