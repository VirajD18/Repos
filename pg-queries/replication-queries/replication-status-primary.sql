-- Display the replication status for the primary server
-- This includes the client address, state, and LSNs
-- that were sent and received on the secondary servers
SELECT   psr.pid
       , psr.client_addr
       , psr.usename
       , psr.application_name
       , psr.state
       , psr.write_lsn
       , psr.flush_lsn
       , psr.replay_lsn
       , EXTRACT(EPOCH FROM psr.write_lag) * 1000  AS write_lag_ms
       , EXTRACT(EPOCH FROM psr.flush_lag) * 1000  AS flush_lag_ms
       , EXTRACT(EPOCH FROM psr.replay_lag) * 1000 AS replay_lag_ms
FROM    pg_stat_replication as psr;


-- Check replication slots
SELECT   rs.slot_name
       , rs.slot_type
       , rs.active
       , rs.restart_lsn 
FROM   pg_replication_slots as rs;

-- Check the WAL sender processes for the secondaries
-- This includes the PID, username, application name, client address, 
-- and backend start time
SELECT    p1.pid
        , p1.usename
        , p1.application_name
        , p1.client_addr
        , p1.backend_start
        , p1.state
FROM    pg_stat_activity as p1
WHERE   p1.backend_type = 'walsender';

-- Query the replication slots with additional details
-- Primary servers should have a slot for each secondary server.
select    rs.slot_name
        , rs.plugin
        , rs.slot_type
        , rs.datoid
        , rs.database
        , rs.temporary
        , rs.active
        , rs.active_pid
        , rs.xmin
        , rs.catalog_xmin
        , rs.restart_lsn
        , rs.confirmed_flush_lsn
        , rs.wal_status
        , rs.safe_wal_size
        , rs.two_phase
        , rs.conflicting
from 	pg_replication_slots as rs;

-- Ensure that you are querying the primary server
-- On the primary server, this should return false
SELECT pg_is_in_recovery();
