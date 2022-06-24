FROM mcr.microsoft.com/mssql/server:2017-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password

RUN mkdir -p /var/opt/mssql/scripts/

#COPY ./restore.sql /var/opt/mssql/scripts/
ADD https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/features/sql-management-objects/prep/restore.sql /var/opt/mssql/scripts/
#COPY ./*.bak /var/opt/mssql/backup/
ADD https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak /tmp/backup/

WORKDIR /var/opt/mssql/scripts/

RUN (/opt/mssql/bin/sqlservr &) | grep -q "Recovery is complete" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i restore.sql

EXPOSE 1433