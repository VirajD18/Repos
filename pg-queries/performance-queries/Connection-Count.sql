\pset format wrapped
-- Connection Count by Application Name
select count(*), state from pg_stat_activity group by state; select count(datid),client_addr,datname,usename,state,application_name from pg_stat_activity group by client_addr,datname,usename,state,application_name order by count(datid) desc;

-- Simple Connection Count 
select count(*), state from pg_stat_activity group by state; select count(*),usename,state,client_addr from pg_stat_activity group by 2,3,4;

-- Active Queries and Count
select count(pid), query from pg_stat_activity where state='active' group by query;
