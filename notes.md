DataLoadSimulation works great within the WWI database, however, it does not seem to work well while using it with SqlWorkload. SqlWorkload appears to wait for the proc execution to finish before it begins syncing all of the events.

However, when testing against normal individual transactions...such as simple inserts, and queries, then the realtime replay works great.

There may be some existing procs that can be used to generate data without using the bulk generation proc like "PopulateDataToCurrentDate".

In order to properly demonstrate a workload syncing, it appears the events need to occur externally. SQLQueryStress could be used for this purpose to demonstrate. But that means some sort of data generation query needs to be built and loaded into SQLQueryStress.

Might be able to build something using the existing DataLoadSimulation procs.

```plaintext
##### Useful commands #####

### Sample run command to spin up a single instance of image
    # docker run -d -p 1433:1433 --name sql wwisql

### docker compose sample commands
    # docker-compose down --remove-orphans -v

### Downloads
    ### SQLQueryStress
    # iwr -Uri https://github.com/ErikEJ/SqlQueryStress/releases/download/102/SqlQueryStress.zip -OutFile .\Downloads\SqlQueryStress.zip
    # Expand-Archive -Path .\Downloads\SqlQueryStress.zip -DestinationPath .\Downloads\SqlQueryStress\

### Needed to run windows containers
    # Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All

### sqlite
    # choco install sqlite.shell
    # sqlite3
    # .open SqlWorkload.sqlite
    # select count(*) from events where database_name = 'WideWorldImporters' group by database_name;

### Install sp_WhoIsActive - if realtime replay is running, this will sync
    # $cred = Get-Credential -UserName sa
    # Install-DbaWhoIsActive -SqlInstance localhost:1433 -SqlCredential $cred -Database master
```