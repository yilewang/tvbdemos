### A tutorial to deploy a TVB server on a HPC cluster

This tutorial will guide you through the steps to deploy a TVB server on a HPC cluster. The tutorial is based on the [TVB server deployment tutorial](https://docs.thevirtualbrain.org/manuals/UserGuide/UserGuide-Config.html)


Documentation of TVB deployment
1. Install the PostgreSQL 12 version to the system (Based on Rocky 8 here) [link](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-rocky-linux-8)


2. Check the website to install no-head version of TVB

The configuration [link](https://docs.thevirtualbrain.org/manuals/UserGuide/UserGuide-Config.html)

- Download TVB to the virtual machine

```
wget https://www.thevirtualbrain.org/tvb/zwei/action/download-latest-pack?docId=364113&os=linux
``` 
You can check the log information in the `wget-log` file.

- Unzip the file

You can use the command `unzip` to unzip the file. If you don't have the `unzip` command, you can install it by `sudo yum install unzip`

After that, a `TVB_Distribution` folder will be generated.

- Add configuration file

You should create a file named `.tvb.configuration` in the home directory of the current OS user which is launching _TheVirtualBrain_.

```
cd ~
touch .tvb.configuration
```

You can copy and paste the following content to the `.tvb.configuration` file.

```
MAXIMUM_NR_OF_OPS_IN_RANGE=2000
ADMINISTRATOR_EMAIL=jira.tvb@gmail.com
MAXIMUM_NR_OF_THREADS=4
WEB_SERVER_PORT=8080
LAST_CHECKED_CODE_VERSION=17803
USR_DISK_SPACE=5242880
DEPLOY_CLUSTER=False
ADMINISTRATOR_NAME=admin
LAST_CHECKED_FILE_VERSION=5
URL_VALUE=postgresql+psycopg2://postgres:rosa@127.0.0.1:5432/tvb?user=rocky&password=rosa
ADMINISTRATOR_PASSWORD=rosa
SELECTED_DB=postgres
MAXIMUM_NR_OF_VERTICES_ON_SURFACE=300000
TVB_STORAGE=/home/rocky/TVB
ADMINISTRATOR_DISPLAY_NAME=Administrator

```

Remember to change `tvb_user` to your own username.

- Setting firewall in the Jetstream 2.

The specific setting for firewall rules can be seen from the image below.
![firewall](firewall.png)


- Setting `PostgreSQL` database

```
# activate postgresql interactive terminal
sudo -u postgres psql postgres

# create a database
CREATE DATABASE tvb;

# create a user
CREATE USER rocky WITH PASSWORD 'rosa';

# grant privileges to the user
GRANT ALL PRIVILEGES ON DATABASE tvb TO rocky;
```

The local firewall setting:

```
sudo firewall-cmd --zone=public --permanent --add-service=http

sudo firewall-cmd --zone=public --permanent --add-port 8080/tcp

sudo firewall-cmd --zone=public --permanent --add-port 8081/tcp
```
GRANT USAGE ON SCHEMA public to rocky


The authentication method in the `pg_hba.conf` file should be changed to `md5` for the user `rocky`.

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     md5
host    replication     all             127.0.0.1/32            trust
host    replication     all             ::1/128                 md5

```

To restart the PostgreSQL service, you can use the following command.

```
sudo service postgresql restart
```

