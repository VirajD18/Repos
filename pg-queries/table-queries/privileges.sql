SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'my_table' AND indexname = 'my_index';

select distinct grantee,privilege_type from information_schema.role_table_grants where grantee='role_name';

SELECT grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name = 'your_table_name';

\z
