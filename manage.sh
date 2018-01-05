#! /usr/bin/env bash


set -e

# cd workdir
cd "$(dirname $0)"


# Aliases are not expanded when the shell is not interactive, 
# unless the expand_aliases shell option is set using shopt 
# (see the description of shopt under SHELL BUILTIN COMMANDS below).
shopt -s expand_aliases
alias docker-compose-alias='docker-compose -f docker/elastic-stack.yml'


function check()
{
  echo -n "checking $1 "
  shift
  if !$* > /dev/null 2>&1
  then
    echo 'failure'
  else
    echo 'success'
  fi
}


function check-prerequisites()
{
  check docker docker --version
  check docker-compose docker-compose --version
  check curl curl --version
}


check-prerequisites


function start-elasticsearch-master()
{
  docker-compose-alias up $* elasticsearch
}


function start-elasticsearch-slave-1()
{
  docker-compose-alias up $* elasticsearch-slave-1
}


function start-elasticsearch()
{
  start-elasticsearch-master $*
  start-elasticsearch-slave-1 $*
}


function start-kibana()
{
  docker-compose-alias up $* kibana
}


function start-logstash()
{
  docker-compose-alias up $* logstash
}


function start-filebeat()
{
  docker-compose-alias up $* filebeat
}


function elasticsearch-health()
{
  curl 'http://localhost:9200/_cluster/health?pretty=true' -o -
}


start-filebeat -d
