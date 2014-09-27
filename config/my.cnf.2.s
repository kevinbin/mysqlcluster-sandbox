[MYSQLD]

port=3337

socket=/tmp/mysql.sock.3337

server-id=3337

log-bin=sandbox_slave2
slave_exec_mode=IDEMPOTENT
binlog_format=row
