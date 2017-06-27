#!/bin/bash

# git pull
git pull origin master

# create executable shell script
mix deps.get
MIX_ENV=$1 mix escript.build

# execute
./stock_scraping_batch
