SELECT relname AS TableName,
       n_live_tup AS LiveTuples,
       n_dead_tup AS DeadTuples
FROM pg_stat_user_tables;

SELECT * FROM pg_stat_user_tables where relname='';

SELECT 
    schemaname || '.' || relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    round((n_dead_tup::numeric / (n_live_tup + n_dead_tup + 1)) * 100, 2) AS dead_tuple_percentage,
    pg_size_pretty(pg_relation_size(relname::regclass)) AS table_size
FROM 
    pg_stat_user_tables
ORDER BY 
    dead_tuple_percentage DESC
LIMIT 20;
