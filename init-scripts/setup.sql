-- TODO change this if changing the DB connection name
\connect postgres;

-- Create tables
create table public.lists (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    name text not null,
    owner_id uuid not null,
    constraint lists_pkey primary key (id)
  );

create table public.todos (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    completed_at timestamp with time zone null,
    description text not null,
    completed boolean not null default false,
    created_by uuid null,
    completed_by uuid null,
    list_id uuid not null,
    photo_id uuid null,
    constraint todos_pkey primary key (id)
  );

-- Creates some initial data to be synced
INSERT INTO lists (id, name, owner_id) VALUES ('75f89104-d95a-4f16-8309-5363f1bb377a', 'Getting Started', gen_random_uuid()  );
INSERT INTO todos(description, list_id, completed) VALUES ('Run services locally', '75f89104-d95a-4f16-8309-5363f1bb377a', true);
INSERT INTO todos (description, list_id, completed) VALUES ('Create a todo here. Query the todos table via a Postgres connection. Your todo should be synced', '75f89104-d95a-4f16-8309-5363f1bb377a', false);

create table public.lww (
  id integer not null,
  v text,
  constraint lww_pkey primary key (id)
);

INSERT INTO lww (id) VALUES (0);
INSERT INTO lww (id) VALUES (1);
INSERT INTO lww (id) VALUES (2);
INSERT INTO lww (id) VALUES (3);
INSERT INTO lww (id) VALUES (4);
INSERT INTO lww (id) VALUES (5);
INSERT INTO lww (id) VALUES (6);
INSERT INTO lww (id) VALUES (7);
INSERT INTO lww (id) VALUES (8);
INSERT INTO lww (id) VALUES (9);
INSERT INTO lww (id) VALUES (10);
INSERT INTO lww (id) VALUES (11);
INSERT INTO lww (id) VALUES (12);
INSERT INTO lww (id) VALUES (13);
INSERT INTO lww (id) VALUES (14);
INSERT INTO lww (id) VALUES (15);
INSERT INTO lww (id) VALUES (16);
INSERT INTO lww (id) VALUES (17);
INSERT INTO lww (id) VALUES (18);
INSERT INTO lww (id) VALUES (19);
INSERT INTO lww (id) VALUES (20);
INSERT INTO lww (id) VALUES (21);
INSERT INTO lww (id) VALUES (22);
INSERT INTO lww (id) VALUES (23);
INSERT INTO lww (id) VALUES (24);
INSERT INTO lww (id) VALUES (25);
INSERT INTO lww (id) VALUES (26);
INSERT INTO lww (id) VALUES (27);
INSERT INTO lww (id) VALUES (28);
INSERT INTO lww (id) VALUES (29);
INSERT INTO lww (id) VALUES (30);
INSERT INTO lww (id) VALUES (31);
INSERT INTO lww (id) VALUES (32);
INSERT INTO lww (id) VALUES (33);
INSERT INTO lww (id) VALUES (34);
INSERT INTO lww (id) VALUES (35);
INSERT INTO lww (id) VALUES (36);
INSERT INTO lww (id) VALUES (37);
INSERT INTO lww (id) VALUES (38);
INSERT INTO lww (id) VALUES (39);
INSERT INTO lww (id) VALUES (40);
INSERT INTO lww (id) VALUES (41);
INSERT INTO lww (id) VALUES (42);
INSERT INTO lww (id) VALUES (43);
INSERT INTO lww (id) VALUES (44);
INSERT INTO lww (id) VALUES (45);
INSERT INTO lww (id) VALUES (46);
INSERT INTO lww (id) VALUES (47);
INSERT INTO lww (id) VALUES (48);
INSERT INTO lww (id) VALUES (49);
INSERT INTO lww (id) VALUES (50);
INSERT INTO lww (id) VALUES (51);
INSERT INTO lww (id) VALUES (52);
INSERT INTO lww (id) VALUES (53);
INSERT INTO lww (id) VALUES (54);
INSERT INTO lww (id) VALUES (55);
INSERT INTO lww (id) VALUES (56);
INSERT INTO lww (id) VALUES (57);
INSERT INTO lww (id) VALUES (58);
INSERT INTO lww (id) VALUES (59);
INSERT INTO lww (id) VALUES (60);
INSERT INTO lww (id) VALUES (61);
INSERT INTO lww (id) VALUES (62);
INSERT INTO lww (id) VALUES (63);
INSERT INTO lww (id) VALUES (64);
INSERT INTO lww (id) VALUES (65);
INSERT INTO lww (id) VALUES (66);
INSERT INTO lww (id) VALUES (67);
INSERT INTO lww (id) VALUES (68);
INSERT INTO lww (id) VALUES (69);
INSERT INTO lww (id) VALUES (70);
INSERT INTO lww (id) VALUES (71);
INSERT INTO lww (id) VALUES (72);
INSERT INTO lww (id) VALUES (73);
INSERT INTO lww (id) VALUES (74);
INSERT INTO lww (id) VALUES (75);
INSERT INTO lww (id) VALUES (76);
INSERT INTO lww (id) VALUES (77);
INSERT INTO lww (id) VALUES (78);
INSERT INTO lww (id) VALUES (79);
INSERT INTO lww (id) VALUES (80);
INSERT INTO lww (id) VALUES (81);
INSERT INTO lww (id) VALUES (82);
INSERT INTO lww (id) VALUES (83);
INSERT INTO lww (id) VALUES (84);
INSERT INTO lww (id) VALUES (85);
INSERT INTO lww (id) VALUES (86);
INSERT INTO lww (id) VALUES (87);
INSERT INTO lww (id) VALUES (88);
INSERT INTO lww (id) VALUES (89);
INSERT INTO lww (id) VALUES (90);
INSERT INTO lww (id) VALUES (91);
INSERT INTO lww (id) VALUES (92);
INSERT INTO lww (id) VALUES (93);
INSERT INTO lww (id) VALUES (94);
INSERT INTO lww (id) VALUES (95);
INSERT INTO lww (id) VALUES (96);
INSERT INTO lww (id) VALUES (97);
INSERT INTO lww (id) VALUES (98);
INSERT INTO lww (id) VALUES (99);

-- Create publication for PowerSync
create publication powersync for table lists, todos, lww;
