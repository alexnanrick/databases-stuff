/* ETL team dimension */ 
drop table stage_teams cascade constraints purge;

create table stage_teams (
  team_sk integer,
  source_db integer,
  team_name varchar(100),
  team_id integer
);

drop sequence stage_team_seq;

create sequence stage_team_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_team_trigger 
before insert on stage_teams
for each row
begin
select stage_team_seq.nextval into :new.team_sk from dual;
end;

insert into stage_teams (source_db, team_name, team_id)
select 1, team_name, team_id from team1;

insert into stage_teams (source_db, team_name, team_id)
select 2, team_name, team_id from team2;

/* Insert from DB 1 */
insert into dim_teams (team_sk, team_name)
  select st.team_sk, st.team_name 
  from stage_teams st
  where not exists (
    select team_name
    from dim_teams dt
    where dt.team_name = st.team_name)
  and source_db = 1; 

/* Insert from DB 2 */
insert into dim_teams (team_sk, team_name)
  select st.team_sk, st.team_name 
  from stage_teams st
  where not exists (
    select team_name
    from dim_teams dt
    where dt.team_name = st.team_name)
and source_db = 2; 

/* ETL players dimension */
drop table stage_players cascade constraints purge;

create table stage_players (
  player_sk integer,
  source_db integer,
  player_id integer,
  player_fname varchar(50),
  player_sname varchar(50),
  team_id integer
);

drop sequence stage_player_seq;

create sequence stage_player_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_player_trigger 
before insert on stage_players
for each row
begin
select stage_player_seq.nextval into :new.player_sk from dual;
end;

insert into stage_players (source_db, player_id, player_fname, player_sname, team_id)
select 1, p_id, p_name, p_sname, team_id from players1;

insert into stage_players (source_db, player_id, player_fname, player_sname, team_id)
select 2, p_id, p_name, p_sname, team_id from players2;

select * from stage_players;

/* Insert from DB 1 */
insert into dim_players (player_sk, player_name)
  select sp.player_sk, sp.player_fname || ' ' || sp.player_sname  
  from stage_players sp
  where not exists (
    select player_name
    from dim_players dp
    where dp.player_name = sp.player_fname || ' ' || sp.player_sname )
  and source_db = 1; 

/* Insert from DB 2 */
insert into dim_players (player_sk, player_name)
  select sp.player_sk, sp.player_fname || ' ' || sp.player_sname  
  from stage_players sp
  where not exists (
    select player_name
    from dim_players dp
    where dp.player_name = sp.player_fname || ' ' || sp.player_sname )
  and source_db = 2; 

/* ETL tournament dimension */
drop table stage_tournaments cascade constraints purge;

create table stage_tournaments (
  tour_sk integer,
  source_db integer,
  tour_id integer,
  tour_desc varchar(100),
  tour_date date,
  tour_prize float
);

drop sequence stage_tournament_seq;

create sequence stage_tournament_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_tournament_trigger 
before insert on stage_tournaments
for each row
begin
select stage_tournament_seq.nextval into :new.tour_sk from dual;
end;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, tour_prize)
select 1, t_id, t_descriprion, t_date, total_price from tournament1;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_date, tour_prize)
select 2, t_id, t_descriprion, t_date, total_price from tournament2;

/* ETL date sk */
drop table stage_dates cascade constraints purge;

create table stage_tournaments (
  tour_sk integer,
  source_db integer,
  tour_id integer,
  tour_desc varchar(100),
  tour_prize float
);

drop sequence stage_tournament_seq;

create sequence stage_tournament_seq
start with 1
increment by 1
nomaxvalue;

create trigger stage_tournament_trigger 
before insert on stage_tournaments
for each row
begin
select stage_tournament_seq.nextval into :new.tournament_sk from dual;
end;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_prize)
select 1, t_id, t_descriprion, t_date, total_price from tournament1;

insert into stage_tournaments (source_db, tour_id, tour_desc, tour_prize)
select 2, t_id, t_descriprion, t_date, total_price from tournament2;
