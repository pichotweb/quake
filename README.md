
# Quake 3 Arena Parser

## Description
Quake 3 Arena Parser is a Rails project that analyzes and displays game statistics for Quake 3 Arena matches. Developed using Ruby 3.2.3 ans Rails 7.

## Requirements
Make sure to have Ruby 3.2.3 installed on your machine before proceeding.

## Installation
1. Clone this repository to your local machine:
```bash
git clone https://github.com/pichotweb/quake-parser
``` 
2.  Navigate to the project directory:
```bash
cd quake-parser 
```     
3.   Install dependencies using Bundler:
```bash
bundle install 
```

## Configuration

1.  The project uses Sqlite3 as default DB, it can be changed at:
    
```bash
config/database.yml
```
2.   Configure the database:

```bash
rails db:create
rails db:migrate
```

## Execution

To start the development server, use the following command:0
```bash
./bin/dev
```
The server will be started at http://localhost:3000 by default.

## Log

For tests purposes, a log file can be found at:
```bash
test/fixtures/files/log.txt
```

