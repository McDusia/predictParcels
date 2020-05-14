# predictParcels

# Set up

Python 3.6

Please install all requirements with

```pip install -r requirements.txt```
# Database import with docker [ linux, mac ]

handy materials:

https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-backup-and-restore-database?view=sql-server-ver15

https://medium.com/@amalrikmaia/how-to-restore-a-sql-server-database-on-ubuntu-437882a134bf

```sudo docker exec -it sqlserver1 mkdir /var/opt/mssql/backup```
  
```docker cp LA_County_DB_newer.bak sqlserver1:/var/opt/mssql/backup```

Run SQL query:
 ```RESTORE DATABASE LosAngeles
 FROM DISK = '/var/opt/mssql/backup/LA_County_DB_newer.bak'
 WITH MOVE 'LosAngelesCounty' TO '/var/opt/mssql/data/LosAngeles.mdf',
 MOVE 'LosAngelesCounty_log' TO '/var/opt/mssql/data/LosAngeles.ldf'
 GO```

# To start docker:
`docker container start containerName`