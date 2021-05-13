Create docker volume for mssql:
docker volume create multiproject_mssql_volume


Run docker container:
docker run -e 'ACCEPT_EULA=Y' --name multiproject_mssql_container -e 'SA_PASSWORD=Password123' -p 1433:1433 -v multiproject_mssql_volume:/var/opt/mssql 62c

Exec in sql docker container:
docker exec -it multiproject_mssql_container bash

sqlcmd (/opt/mssql-tools/bin/sqlcmd) 


restart container
docker restart multiproject_mssql_container


docker build -t multiproject/AuthenticationServer .


Stupid window config !!!
net stop winnat
net start winnat