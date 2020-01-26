# Shell OAI Harvester
The OAI-PMH Shell Harvester is able to harvest OAI-PMH targets. It supports multiple configurable targets which can be updated individually. Furthermore, it is able to execute a preset command for each record it updates or deletes.
View the [CHANGELOG](CHANGELOG.md) for important changes.

## Installation

### Dependencies
 - xsltproc (libxslt)
 - bc
 - curl
 - coreutils
 - grep

### Manual Install
Use sudo/root where needed.
 - git clone https://github.com/wimmuskee/shell-oaiharvester.git
 - cd shell-oaiharvester
 - cp oaiharvester /usr/bin/oaiharvester
 - mkdir /usr/share/shell-oaiharvester
 - cp libs/* /usr/share/shell-oaiharvester/.
 - mkdir /etc/shell-oaiharvester
 - cp config.example.xml /etc/shell-oaiharvester/config.xml

## Usage

### Configuration
The harvester has several configuration options that apply to the general behaviour while other options are repository specific.
Different config files can be used with different levels of precedence (without fallback).
1. commandline option provided location: `oaiharvester -c <config file>`
2. *$HOME/.config/shell-oaiharvester/config.xml*
3. */etc/shell-oaiharvester/config.xml*

Some notes on the options:
 - deletecmd: executed before a record is deleted, optional
 - updatecmd: executed after a record is updated, optional
   - ${identifier} holds the identifier
   - ${filename) is the identifier with optional xz extension
   - ${path} holds the absolute path of the record
   - ${responsedatetime} the full oai page responsedate
   - ${responsedate} the YYYY-MM-DD format of responsedatetime
 - repository update and delete cmd's are executed before the generic ones if available
 - set, from, until, conditional and recordpath are optional

### Operation
View all available options:
```oaiharvester -h```

To harvest records from a specified repository, run:
```oaiharvester -r <repository_id>```

To only retrieve identifiers:
```oaiharvester -r <repository_id> -n```

Not harvest, but validate the repository
```oaiharvester -r <repository_id> -t```

To list configured repositories:
```oaiharvester -l```

### Logs
Unless customized, the log file of the harvest process is stored at */tmp/oaiharvester-log.csv*. The logger uses a simple csv format with a line for each downloaded page:
```YYYY-MM-DD HH:MM:SS,PID,repository,record count,download time,process time```.

A recordlog can also be set, by default at */dev/null* because depending on repositories this file can increase in size a lot. This has the following format:
```YYYY-MM-DD HH:MM:SS,repository,record datestamp,record identifier```.

### Status
Once harvested, each repository directory will hold a status file. In version 1, this is *lasttimestamp.txt* containing just the timestamp where the harvester should continue.
Starting from version 2, a hidden *.oaiharvester* file is used to contain not only the timestamp, but also harvester version information which should help with future migrations.
