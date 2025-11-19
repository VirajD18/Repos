-- Ensure that you are querying a secondary server
-- On a secondary server, this should return true
SELECT  pg_is_in_recovery();
select now()-pg_last_xact_replay_timestamp() as replication_lag;
-- Check the replication lag in bytes and time
-- This includes the lag in bytes and the lag in time
-- along with the last received and replayed LSN numbers
-- These should match but can be off by a few bytes or milliseconds.
SELECT   pg_last_wal_receive_lsn()
       , pg_last_wal_replay_lsn()
       , pg_last_xact_replay_timestamp()
       , pg_last_wal_receive_lsn() - pg_last_wal_replay_lsn() as lag_bytes
       , now() - pg_last_xact_replay_timestamp() AS replication_lag_time;

-- Check replication status on the secondary
-- This includes the last received LSN 
-- and last replayed LSN
SELECT   wr.status
       , wr.sender_host
       , wr.receive_start_lsn
       , wr.written_lsn
       , wr.flushed_lsn
       , pg_size_pretty(pg_wal_lsn_diff(wr.written_lsn, wr.flushed_lsn)) as applied_delta       
       , wr.latest_end_lsn
       , wr.last_msg_send_time
       , wr.last_msg_receipt_time
FROM   pg_stat_wal_receiver as wr;

-- Query the table pg_stat_wal_receiver to get the replication status for the secondary server
-- with additional information.
select    wr.pid
        , wr.status
        , wr.receive_start_lsn
        , wr.receive_start_tli
        , wr.written_lsn
        , wr.flushed_lsn
        , wr.received_tli
        , wr.last_msg_send_time
        , wr.last_msg_receipt_time
        , wr.latest_end_lsn
        , wr.latest_end_time
        , wr.slot_name
        , wr.sender_host
        , wr.sender_port
from    pg_stat_wal_receiver wr;

-- Query the replication slots. 
-- Secondary servers should have a slot for the primary server.
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
