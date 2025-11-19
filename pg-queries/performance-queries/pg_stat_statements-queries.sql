--Top 20 slowest queries
SELECT userid::regrole,datname as dbname,  substring(query, 1, 100) AS short_query,
round(total_exec_time::numeric, 2) AS total_exec_time,calls,round(mean_exec_time::numeric, 2) AS mean,
round((100 * total_exec_time /sum(total_exec_time::numeric) OVER ())::numeric, 2) AS percentage
FROM    pg_stat_statements
inner join pg_database
on dbid=oid
ORDER BY total_exec_time DESC
limit 20;

--top time consuming
select userid::regrole, datname as dbname, substring(query, 1, 100) AS short_query,
calls, total_exec_time/1000 as total_time_seconds ,min_exec_time/1000 as min_time_seconds,
max_exec_time/1000 as max_time_seconds,mean_exec_time/1000 as mean_time_seconds
from pg_stat_statements
inner join pg_database
on dbid=oid
order by mean_exec_time desc
limit 20;

-- pg stat statements reset

select pg_stat_statements_reset() ;

\dv+ pg_stat_statements		--(checking size)
