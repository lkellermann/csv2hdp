# csv2hdp

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

## About <a name = "about"></a>

`csv2hdp` is a simple shell script module that loads data from a`csv` file into a Hive table.

## Getting Started <a name = "getting_started"></a>


### Prerequisites
To use this script you need access to an Hive server able to execute a Shell script.

### Installing
To use this script you need to define the following environment variables:
- **`HIVE_HOME`**: the Apache Hive home path.
- **`CSV2HDP`**: directory where the `csv2hdp.sh` will be.
- **`STAGING_CSV`**: directory to stage the `.csv` files to be transfer to Hive.
- **`HIVE_JDBC`**: JDBC connection string to access Hive.

## Usage <a name = "usage"></a>
To use this script you must place a `.csv` file at the path defined by `STAGING_CSV`. After this login to Hive Server and run the following command:

```shell
csv2hdp.sh -f sample.csv -d default
```

or...

```shell
 csv2hdp.sh --file sample.csv --database default
```
## Available flags
- `-h, --help`: show the help message.
- `-f, --file`: name of the file to be transfer.
- `-d, --database`: destiny database.