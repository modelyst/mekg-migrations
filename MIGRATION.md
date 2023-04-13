## Migration

To migrate the data from PostgreSQL to Neo4j, you can use the following steps:
#### Restore PostgreSQL backups

To restore a specific backup, run the following command from the root of the repository:

```Bash
POSTGRES_BACKUP_FILE=public_release_20230228_eighth.tar.gz docker-compose run --rm postgres-loader
```

This command will start the PostgreSQL Docker container and then run a loading service that takes the backup file and loads it into the database. Note that you should replace public_release_20230228_eighth.tar.gz with the name of the specific backup file you want to restore.

#### Dump the PostgreSQL database

The Neo4j database is created from a set of CSV files generated from the PostgreSQL database. To generate these CSV files, run the following command from the root of the repository:

```Bash
docker-compose run --rm pg4j dump
```

This command will generate CSV files in the data/pg4j_output/ directory.

#### Load the migrated data into Neo4j

To load the CSV files into the Neo4j database, run the following command from the root of the repository:

```Bash
docker-compose run --rm pg4j import
```

This command will start the pg4j Docker container, which will load the CSV files into the Neo4j database.

#### Start Neo4j

To start the Neo4j server, run the following command from the root of the repository:
```Bash
docker-compose up neo4j -d
```

This command will start the Neo4j Docker container in detached mode, which means that it will run in the background. Once the container is running, you can access the Neo4j browser by navigating to <http://localhost:7474> in your web browser.

Note that you may need to wait a few moments for the database to finish loading before you can access it in the browser.


