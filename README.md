# csv2hdp

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

## About <a name = "about"></a>

This is actually a scratch of a `shell` application to transport small `csv` files from client to Hadoop. There is too much `#TODO` yet... but I'm commiting now because I don't want to miss what I did because some fault on my computer... :grin: 

## Getting Started <a name = "getting_started"></a>
`#TODO`

### Prerequisites

Access to an Hadoop environment.




### Installing
You shouldn't install anything in production, just run the command. But since I'll have to create a testing environment, so I'll provide the steps to crete the testing environment.

## Usage <a name = "usage"></a>

We want to transfer a `csv`file from client machine to hadoop environment by running something like the following command:

```shell
 ./csv2hdp.sh -f ./sample.csv -d mydb
```

or...

```shell
 ./csv2hdp.sh --file ./sample.csv --database mydb
```

> `#TODO`: I'll deploy this in the Hadoop environment. So probably the command should be something starting as `csv2hdp.sh` instead of `./csv2hdp.sh`.
