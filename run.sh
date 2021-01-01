#!/bin/bash

set -o errexit
set -o nounset

# GLOBAL VARIABLES
PACKAGES="docker docker-compose"
JUPYTERSPARK="jupyterspark"

# SCRIPT METHODS
#
# Install docker and docker-compose
install_docker()
{
  printf "Installing Docker...\n"

  sudo apt remove --yes docker docker-engine docker.io containerd runc
  sudo apt update
  sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
  wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
  sudo apt update
  sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
  sudo usermod --append --groups docker "$USER"
  sudo systemctl enable docker

  printf '\nDocker installed successfully\n\n'
  printf 'Waiting for Docker to start...\n\n'
  sleep 5
}
install_docker_compose()
{
  printf "Installing Docker Compose...\n"

  sudo wget --output-document=/usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')/run.sh"
  sudo chmod +x /usr/local/bin/docker-compose
  sudo wget --output-document=/etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose"
  
  printf '\nDocker Compose installed successfully\n\n'
}
install_entites()
{
  # check if docker is installed
  printf "\nChecking required packages\n"
  for i in $PACKAGES
    do
      if ! which $i > /dev/null; then
        if [ $i == 'docker' ]; then
          # Docker
          install_docker
        elif [ $i == 'docker-compose' ]; then
          # Docker Compose
          install_docker_compose
        else
          printf "No packages found!\n"
      else
        printf "${i^^} already installed \n"
      fi
  done

  printf "Docker and Docker-Compose installed, logging you out in 5s, kindly log back in...\n"
  sleep 5
  exit
}

#Jupyter Spark Edition - Python, R, and Scala support for Apache Spark
get_jupyterspark_logs()
{
  # getting last log
  printf "\nRetrieving Jupyter Spark last log...\n"
  docker logs ${JUPYTERSPARK}
}
boot_jupyterspark()
{
  # inform
  printf "Creating required directories...\n"
  mkdir /home/$USER/jupytersparkdata

  # inform
  printf "Running standalone jupyter container now...\n"

  # docker command
  docker run -d --name ${JUPYTERSPARK} -p 8888:8888 -p 4040:4040 -p 4041:4041 -e RESTARTABLE=yes -v /home/$USER/jupytersparkdata:/home/jovyan/work jupyter/pyspark-notebook

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
  1. Install docker and docker-compose
  2. Jupyter Spark - Start
  3. Jupyter Spark - Stop & Remove
  4. Jupyter Spark - Logs
  0. Quit
  " optionvar

  # run option
  if [ $optionvar -eq 1 ]; then
    printf "\nInstalling docker and docker-compose\n\n"
    install_docker_entites
  elif [ $optionvar -eq 2 ]; then
    printf "\nBooting up Jupyter Spark\n\n"
    boot_jupyterspark
  elif [ $optionvar -eq 3 ]; then
    printf "\nShutting down Jupyter Spark\n\n"
    shutdown_jupyterspark
  elif [ $optionvar -eq 4 ]; then
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