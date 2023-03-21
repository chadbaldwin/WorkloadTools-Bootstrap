FROM mcr.microsoft.com/mssql/server:2017-latest

# Not sure why these need to be specified here...it appears that when you "build" an image it also runs it.
# Since these are required by the mssql image, it will break if you don't supply them.
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=yourStrong(!)Password

# Download WideWorldImporters database backup and sample restore file
ADD https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/features/sql-management-objects/prep/restore.sql /tmp/backup/
# Directory must be /tmp/backup if using their restore file as that's the path they hardcoded
ADD https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak /tmp/backup/

RUN (/opt/mssql/bin/sqlservr &) | grep -q "Recovery is complete" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i /tmp/backup/restore.sql

EXPOSE 1433
