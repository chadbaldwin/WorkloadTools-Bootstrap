### Build the image ahead of time so that we can reference it by name in the docker-compose file
docker build -t wwisql .



##### Useful commands #####

### Sample run command to spin up a single instance of image
    # docker run -d -p 1433:1433 --name sql wwisql

### docker compose sample commands - I prefer to run them in interactive mode
    # docker-compose up -d --abort-on-container-exit --remove-orphans
    # docker-compose down --remove-orphans -v

### Downloads
    # New-Item -Name Downloads -ItemType Directory -Force

    ### Workload tools installer
    # iwr -Uri https://github.com/spaghettidba/WorkloadTools/releases/download/v1.5.17/WorkloadTools_x64.exe -OutFile .\Downloads\WorkloadTools_x64.exe
    ### Install WorkloadTools passively - Default behavior is to restart if you don't specify
    # .\WorkloadTools_x64.exe /install /passive /norestart

    ### SQLQueryStress
    # iwr -Uri https://github.com/ErikEJ/SqlQueryStress/releases/download/102/SqlQueryStress.zip -OutFile .\Downloads\SqlQueryStress.zip
    # Expand-Archive -Path .\Downloads\SqlQueryStress.zip -DestinationPath .\Downloads\SqlQueryStress\

### Add WorkloadTools directory to path env variable
    # [Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\WorkloadTools", [EnvironmentVariableTarget]::Machine)

### Needed to run windows containers
    # Enable-WindowsOptionalFeature -Online -FeatureName $("Microsoft-Hyper-V", "Containers") -All

### Run SqlWorkload
    # SqlWorkload -F .\SqlWorkload_WriteToFile.json

### sqlite
    # choco install sqlite.shell
    # sqlite3
    # .open SqlWorkload.sqlite
    # select count(*) from events where database_name = 'WideWorldImporters' group by database_name;

### Install sp_WhoIsActive - if realtime replay is running, this will sync
    # $cred = Get-Credential -UserName sa
    # Install-DbaWhoIsActive -SqlInstance localhost:1433 -SqlCredential $cred -Database master
