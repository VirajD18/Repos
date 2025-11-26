-- Table Only
SELECT
    grantee,
    table_schema,
    table_name,
    string_agg(DISTINCT privilege_type, ', ' ORDER BY privilege_type) AS privileges
FROM
    information_schema.role_table_grants
WHERE table_schema NOT IN ('information_schema', 'pg_catalog', 'access360') AND table_name NOT LIKE 'pg_%'
GROUP BY grantee, table_schema, table_name
ORDER BY table_schema, table_name, grantee;

--- ALL Object ---
WITH all_privs AS (
    -- Tables & Views
    SELECT 
        grantee,
        table_schema AS schema_name,
        table_name AS object_name,
        'TABLE/VIEW' AS object_type,
        privilege_type
    FROM information_schema.role_table_grants
    WHERE table_schema NOT IN ('information_schema','pg_catalog','acess360')
      AND table_name NOT LIKE 'pg_%'
 
    UNION ALL
 
    -- Sequences (using pg_catalog)
    SELECT 
        grantee,
        n.nspname AS schema_name,
        c.relname AS object_name,
        'SEQUENCE' AS object_type,
        privilege_type
    FROM information_schema.role_table_grants g
    JOIN pg_catalog.pg_class c ON g.table_name = c.relname
    JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
    WHERE c.relkind = 'S'  -- S = sequence
      AND n.nspname NOT IN ('pg_catalog','information_schema','acess360')
 
    UNION ALL
 
    -- Functions
    SELECT 
        grantee,
        routine_schema AS schema_name,
        routine_name AS object_name,
        'FUNCTION' AS object_type,
        privilege_type
    FROM information_schema.role_routine_grants
    WHERE routine_schema NOT IN ('information_schema','pg_catalog','acess360')
)
SELECT 
    grantee,
    schema_name,
    object_name,
    object_type,
    STRING_AGG(privilege_type, ', ' ORDER BY privilege_type) AS privileges
FROM all_privs
GROUP BY grantee, schema_name, object_name, object_type
ORDER BY schema_name, object_name, grantee;
