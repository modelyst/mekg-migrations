# mekg-migrations
Code for instantiating and migrating Materials Provenance Store (MPS) and Materials Experiment Knowledge Graph (MEKG) databases. Please see the corresponding MEKG and MPS papers for additional details.

## Overview
The code in this repository was used for several key database setup and metric generation tasks:

- Downloading and restoring MPS postgresql dump files
- Downloading and restoring MEKG neo4j dump files
- Migrating an instantiated postgresql MPS database to a neo4j MEKG database
- Running query times against each database to measure performance
- Instantiating a Jupyter notebook connected to each database for easy scripting access

## Dependencies
- [docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/)


## Downloading Database Dump files

To download the PostgreSQL and Neo4j database dump files, you can use the download-dumps.sh script provided in this repository. This script can be used to download the dump files for either or both databases.

#### Usage
To download the PostgreSQL dump file, run the following command from the root of the repository:
```Bash
scripts/download-releases.sh --postgresql
```
This will download the PostgreSQL dump file to the `data/releases/postgres` directory.
To download the Neo4j dump file, run the following command from the root of the repository:

```Bash
scripts/download-releases.sh --neo4j
```
This will download the Neo4j dump file to the `data/releases/neo4j` directory.

By default, the dump files will be saved to the data directory relative to the location of the script. If you want to change the output directory, you can modify the download-releases.sh script accordingly.

Note that the download links may expire after some time. If the links are no longer valid, you may need to obtain new links from the authors.

## Restoring MPS

The postgresql MPS database can be restored into a postgresql docker container using a loading container.

Once the relevant postgresql has been downloaded it can be loaded into the postgresql docker container volume with the following command:

```
docker-compose run --rm postgres-loader
```

If the name of the release dump file is different than `public-release.dump.` it can be configured by setting the `DUMP_FILE` environmental variable prior to loading

```Bash
POSTGRES_BACKUP_FILE=public_release_20230228_eighth.tar docker-compose run --rm postgres-loader
```

### Connecting to MPS database
The MPS postgresql database can be directly connected to after installation if you have the `psql` postgresql client utility installed:
```Bash
PGPASSWORD=mps_password psql -p 7777 -d postgres -Umps_user -h localhost
```

This requires the postgres container to be running (it will be in the running state after loading the database). If the container has stopped, you can restart it with the following command:

```Bash
docker-compose up postgres 
```

## Restoring MEKG
Once the relevant `neo4j.dump` has been downloaded the MEKG neo4j database can be instantiated with the following docker-compose command:

```Bash
docker-compose run --rm neo4j-loader
```
This will run the `neo4j-admin database load` command and load the instantiate the neo4j database in a docker volume.

Due to a limitation of the `neo4j-admin` utility the file must be named `neo4j.dump` in the `data/releases/neo4j` folder. 

#### Starting MEKG
Once the MEKG dump has been restored the neo4j database can be started with the following command:
```Bash
docker-compose up neo4j -d
```
#### Connecting to MEKG
Once the MEKG dump has been restored the neo4j you can navigate to http://localhost:7474/ to view the database in the neo4j-browser application. The authentication is turned off by default so you can simply click the connect button without filling in the credentials.

The database can also be interacted with programatically through a connection at http://localhost:7687
## Starting Jupyter

Once the database has succesfully been loaded the jupyter server can be turned on with a simple docker-compose up command

```Bash
docker-compose up jupyter -d
```

`-d` is appended here to start the servers in detached mode to run the servers in the background.


#### Connecting to Jupyter
The server can be found at http://localhost:8888. The [mps-client](https://github.com/modelyst/mps-client) library has been pre-seeded with the credentials required to connect to both database. An example notebook has been provided for running queries against each database in `src/QueryTimings.ipynb`


## Migration from MPS to MEKG
See [Migration](MIGRATION.md)


## Turning off databases
All containers can be turned off with a full docker-copmose down command

```Bash
docker-compose down
```

This will preserve the volumes on the databases so that on restart data does not need to be reloaded. To fully delete the datbase volumes and the storage they consume add the -v flag.

```Bash
docker-compose down -v
```