-- invalid index by size
SELECT
    n.nspname AS schema_name,
    t.relname AS table_name,
    c.relname AS index_name,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM
    pg_class c
JOIN
    pg_index i ON c.oid = i.indexrelid
JOIN
    pg_class t ON i.indrelid = t.oid
JOIN
    pg_namespace n ON n.oid = c.relnamespace
WHERE
    c.relkind = 'i'
    AND i.indisvalid = FALSE
    AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_temp','pg_toast')
ORDER BY
    total_size DESC;

-- for perticular table
SELECT
    n.nspname AS schema_name,
    t.relname AS table_name,
    c.relname AS index_name,
    pg_get_indexdef(i.indexrelid) AS index_definition
FROM
    pg_class c
JOIN
    pg_index i ON c.oid = i.indexrelid
JOIN
    pg_class t ON i.indrelid = t.oid
JOIN
    pg_namespace n ON n.oid = c.relnamespace
WHERE
    t.relname = 'operation_exec'  -- Filter for your specific table name
    AND n.nspname = 'public'      -- Specify the schema (e.g., 'public')
    AND c.relkind = 'i'           -- Ensure it's an index
    AND i.indisvalid = FALSE       -- CRUCIAL: Only show indexes marked as valid
ORDER BY
    index_name;

-- dropping invalid index
SELECT
    'DROP INDEX CONCURRENTLY ' || n.nspname || '.' || c.relname || ';'
FROM
    pg_class c                             -- c is the index
JOIN
    pg_index i ON c.oid = i.indexrelid
JOIN
    pg_class t ON i.indrelid = t.oid       -- t is the parent table
JOIN
    pg_namespace n ON n.oid = c.relnamespace
WHERE
    i.indisvalid = FALSE
    AND t.relname = 'operation_exec'      -- ★ CRUCIAL: Filter by the table name
    AND n.nspname NOT IN ('pg_catalog', 'information_schema')
    AND c.relkind = 'i'
ORDER BY
    c.relname;
