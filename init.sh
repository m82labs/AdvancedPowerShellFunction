#!/bin/bash

## Launch two SQL instances
docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=myStrongPassword01' -p 1433:1433 --name sql1 -d microsoft/mssql-server-linux:2017-latest 
docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=myStrongPassword01' -p 1434:1433 --name sql2 -d microsoft/mssql-server-linux:2017-latest 
