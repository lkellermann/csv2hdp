# csv2hdp

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

## About <a name = "about"></a>

`csv2hdp` is a simple shell script that loads data from a`csv` file into a Hive.

## Getting Started <a name = "getting_started"></a>


### Prerequisites
To run the shell script properly you will need to install the [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).
### Installing
After downloading this repository you should start the services from `docker-compose.yml`. Suppose that you're inside the root of this repository and with the docker engine running, you should execute the following commands:
```shell
cd docker-engine
docker-compose up
```

Your services will be up when you see in your terminal something like this:
```shell
hive-metastore_1             | YYYY-MM-DDTHH:MM:SS,XXX INFO [pool-7-thread-2] org.apache.hadoop.hive.metastore.HiveMetaStore - 1: source:X.X.X.X get_all_databases
hive-metastore_1             | YYYY-MM-DDTHH:MM:SS,XXX INFO [pool-7-thread-2] org.apache.hadoop.hive.metastore.HiveMetaStore - 1: source:X.X.X.X get_all_tables: db=default
hive-metastore_1             | YYYY-MM-DDTHH:MM:SS,XXX INFO [pool-7-thread-2] org.apache.hadoop.hive.metastore.HiveMetaStore - 1: source:X.X.X.X get_multi_table : db=default tbls=sample
```

## Usage <a name = "usage"></a>

To run a test in the provided environment you have to enter into `docker-hive_hive-server_1
` container by the following command:

```shell
docker container exec -it docker-hive_hive-server_1 /bin/bash
```

And to run the test you should execute

```shell
 /home/csv2hdp/csv2hdp.sh -f ./sample.csv -d default
```

or...

```shell
 /home/csv2hdp/csv2hdp.sh --file ./sample.csv --database default
```