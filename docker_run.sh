#!/bin/bash

# GLOBAL VARIABLES
PACKAGES="docker docker-compose"
JUPYTERSPARK="jupyterspark"

# SCRIPT METHODS
#
#Jupyter Spark Edition - Python, R, and Scala support for Apache Spark
get_jupyterspark_logs()
{
  # getting last log
  printf "\nRetrieving Jupyter Spark last log...\n"
  docker logs ${JUPYTERSPARK}
}
boot_jupyterspark()
{
  # check if docker is installed
  printf "\nChecking required packages\n"
  for i in $PACKAGES
    do
      if ! which $i > /dev/null; then
        printf "Kindly install ${i^^} to continue - https://www.docker.com \n"
      fi
  done

  # found now proceed
  printf "Docker is installed, running standalone container now...\n"

  # docker command
  docker run -d --name ${JUPYTERSPARK} -p 8888:8888 -p 4040:4040 -p 4041:4041 -e RESTARTABLE=yes -v /home/clonne/git/dev/jupytersparkdata:/home/jovyan/work jupyter/pyspark-notebook

  # pause
  printf "\nContainer is up, waiting to show access url and token\n"
  sleep 5s

  # getting last log
  get_jupyterspark_logs

  # close
  printf "\nJupyter Spark processed successfully\n"
}
shutdown_jupyterspark()
{
  # notify and stop
  printf "\nClosing running container\n"
  docker stop ${JUPYTERSPARK}

  # pause
  sleep 3s

  # notify and remove
  printf "\nRemoving running container\n"
  docker rm ${JUPYTERSPARK}

  # close
  printf "\nStopped and Removed running container successfully\n"
}

# Options runner
boot_options()
{
  read -p "Choose a boot option by number: 
  1. Jupyter Spark - Start
  2. Jupyter Spark - Stop & Remove
  3. Jupyter Spark - Logs
  0. Quit
  " optionvar

  # run option
  if [ $optionvar -eq 1 ]; then
    printf "\nBooting up Jupyter Spark\n\n"
    boot_jupyterspark
  elif [ $optionvar -eq 2 ]; then
    printf "\nShutting down Jupyter Spark\n\n"
    shutdown_jupyterspark
  elif [ $optionvar -eq 3 ]; then
    printf "\View logs for Jupyter Spark\n\n"
    get_jupyterspark_logs
  elif [ $optionvar -eq 0 ]; then
    printf "\nQuitting...\n\n"
    exit
  else
    printf "\nKindly select an option if you want to proceed...\n\n"
  fi
}

# run
boot_options