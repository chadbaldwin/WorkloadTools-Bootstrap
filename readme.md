# Getting Started

The goal of this solution is to set up a working demonstration of spaghettidba's WorkloadTools in action, specifically realtime replay between two SQL Server instances.

To make this as simple as possible, we're going to use Docker, Docker Compose and Dockerfiles's.

All of the commands listed are assumed to be run at the root of this repository

----

## Installing WorkLoadTools

```powershell
### Create a new downloads directory to store downloaded files in (this directory is already ignored in the repository)
New-Item -Name downloads -ItemType Directory -Force

### Download the installer from GitHub referencing the latest (as of this writing) release:
iwr -Uri https://github.com/spaghettidba/WorkloadTools/releases/download/v1.5.17/WorkloadTools_x64.exe -OutFile .\downloads\WorkloadTools_x64.exe

### Install WorkloadTools
.\downloads\WorkloadTools_x64.exe /install /passive /norestart

### Add WorkloadTools to your path variable
[Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\WorkloadTools", [EnvironmentVariableTarget]::Machine)
```

----

## Setting up the environment in Docker

First, build the Docker image, which uses the SQL Server on Linux image, and loads the WideWorldImporters databsae backup so it can be restored.

Build the image using:

```plaintext
docker build -t wwisql .\docker\
```

It will take a minute or two for it to download the dependencies and build the image.

Now we've got an image ready to go. When used, It will spin up an instance of SQL Server and automatically restore the WideWorldImporters database.

In order to set up realtime replay, we need to get two instances running...One to be our "source" instance where WorkLoadTools will record the events from, and one to be our "target" instance for WorkLoadTools to replay the events back to.

Be careful running this locally, as it can easily suck up RAM if you're not careful. I've configured the docker-compose file to limit the containers to 2GB of RAM...but other underlying processes may try to steal more than that.

Start up the environment using:

```plaintext
docker-compose up -d --remove-orphans
```

This will create two separate instances of SQL Server. Both are accessible locally:

* Username: `sa`
* Password: `yourStrong(!)Password`
* Source: `localhost:1433` (default port)
* Target: `localhost:2433`
  * Just a note, if you are trying to specify a non-default port within a connection string, or in SSMS, make sure you specify it using a comma like this `localhost,2433`. Don't let that one bite you, cause it will.

Wait a few mintues for the instances to spin up and restore the databases. You can log into them using SSMS and run some simple queries against the `WideWorldImporters` database to make sure it's all up and running.

----

## Setting up realtime replay

Once it's ready, it's time to start replaying events. WorkloadTools makes this extremely easy. You configure a .json file with the source and target(s), and it's as simple as this:

```plaintext
SqlWorkload -F .\sqlworkload\SqlWorkload_RealtimeReplay.json
```

That's it. As long as you don't see any error messages up to this point, SqlWorkload should be syncing events in realtime from the source instance on port 1433 to the target instance on port 2433.

Try running some simple queries just to see them syncing over.

----

## Mocking activity using SQLQueryStress

The WideWorldImporters database has various stored procedures that can be used to generate data for the database. However, I found that when trying to run the suggested proc from Microsoft (`DataLoadSimulation.PopulateDataToCurrentDate`), I found that SqlWorkload sat, waited, recorded events...but did not replay them until I stopped the execution of the stored procedure.

> ##TODO - Need to look into the other DataLoadSimulation stored procedures to see if any could be used directly to help mock events on the Source instance. And/Or if we need to run them via SQLQueryStress
