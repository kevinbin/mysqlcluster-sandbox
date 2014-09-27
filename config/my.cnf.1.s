[MYSQLD]
port=3336
socket=/tmp/mysql.sock.3336

server-id=3336

log-error=error.log

log-bin=sandbox_slave1
binlog_format=row
slave_exec_mode=IDEMPOTENT
