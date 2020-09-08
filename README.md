# Predict Parcels
## Short description

The real estate market is still developing and many purchase transactions take place every year, such as selling different types of properties which are in different stages of the legal process. Estimating the price of land is very useful, not only for calculating taxes, but also for individuals who wish to purchase property, and also for large plots of land needed, for example, to build railway routes. Manual real estate valuation is very time consuming and requires qualified staff, which is why there is a need for automation in this area. 

The goal of the thesis was to research machine learning algorithms for property valuation and compare them, taking into account the impact of various attributes on the final price. Related works in this field usually focused on one method. Furthermore, the majority of related research only considered basic attributes of the property, and did not examine the surrounding area and attributes that the land was found in. The full review of the related work is described in detail in Chapter 2. 

In order to credibly compare the algorithms, a reliable dataset was necessary. Research was based on sale transactions from Los Angeles County from 2014 to the end of 2016. The methodology in choosing a proper dataset was described in Chapter 3. The sales price range is very large, so it was decided to also test the algorithm on smaller subgroups of the entire set. 

In order to do this, the classification of algorithms was also examined. The following algorithms were tested; neural networks, methods of the nearest neighbours, random forest, support vector methods. The results are described in Chapter 5. 

This thesis proved that it is possible to use automation in order to determine property prices. Moreover, choosing proper property attributes is crucial for better model performance.

## Set up

Python 3.6

Please install all requirements with

```pip install -r requirements.txt```
## Database import with docker [ linux, mac ]

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
