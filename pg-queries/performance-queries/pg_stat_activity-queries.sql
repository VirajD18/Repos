-- Query running more than 5 min
SELECT
          now() - backend_start AS runtime,
          pid,
          usename,
          application_name,
          backend_start,
          state,
          state_change,
          substr(query, 1, 200) the_query
          FROM
          pg_stat_activity
        WHERE
          state <> 'idle'
          AND now() - xact_start > interval '5 minutes'
          and usename <> 'replication'
        ORDER BY
          runtime DESC;

-- Top long running active sessions
select pid,datname,usename,application_name,client_addr,now()-pg_stat_activity.query_start As duration,state,left(query,100) from pg_stat_activity where state='active' and usename not in ('replication', 'pgsqladmin', 'psqladmin')order by duration desc;

-- Idle Sessions
SELECT pid, usename, application_name, client_addr, client_port, now() - backend_start AS BACKEND, now() - query_start AS "QUERY START", now() - state_change AS "STATE CHANGE", state, wait_event, wait_event_type, left(query, 20) FROM pg_stat_activity where now() - state_change > '1 MIN'::INTERVAL ORDER BY 5 desc;
