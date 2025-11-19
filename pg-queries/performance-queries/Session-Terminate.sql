-- Terminate by State
select pg_terminate_backend(pid) from pg_stat_activity where state in ('idle') and usename = 'username';

-- Terminate by database
SELECT 
    pg_terminate_backend(pid) 
FROM 
    pg_stat_activity 
WHERE 
    datname = 'document' 
AND 
    pid <> pg_backend_pid();
