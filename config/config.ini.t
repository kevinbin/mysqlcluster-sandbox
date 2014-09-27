[TCP DEFAULT]
SendBufferMemory=256K
ReceiveBufferMemory=256K

[NDB_MGMD DEFAULT]
PortNumber=1186
Datadir=_DATADIR

[NDB_MGMD]
Id=1
Hostname=localhost

[NDBD DEFAULT]
NoOfReplicas=2
Datadir=_DATADIR
DataMemory=256M
SharedGlobalMemory=64M
DiskPageBufferMemory=32M
IndexMemory=43M
LockPagesInMainMemory=0

MaxNoOfConcurrentOperations=32768

StringMemory=25
MaxNoOfTables=512
MaxNoOfOrderedIndexes=256
MaxNoOfUniqueHashIndexes=256
MaxNoOfAttributes=5000
DiskCheckpointSpeedInRestart=100M
FragmentLogFileSize=256M
NoOfFragmentLogFiles=3
RedoBuffer=8M

HeartbeatIntervalDbDb=15000
HeartbeatIntervalDbApi=15000
TimeBetweenLocalCheckpoints=20
TimeBetweenGlobalCheckpoints=1000
TimeBetweenEpochs=100

TimeBetweenEpochsTimeout=32000

MemReportFrequency=30
BackupReportFrequency=30
[NDBD]
Id=2
Hostname=localhost

[NDBD]
Id=3
Hostname=localhost

[MYSQLD]
Hostname=localhost

[MYSQLD]
Hostname=localhost

[MYSQLD]
Hostname=localhost

[MYSQLD]
Hostname=localhost

[MYSQLD]
Hostname=localhost

[MYSQLD]
Hostname=localhost

