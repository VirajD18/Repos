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
