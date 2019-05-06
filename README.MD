# SCP Secret Laboratory with Servermod and Multiadmin in docker

Explanation on "what is docker"
https://www.docker.com/resources/what-container

The goal of this repo is to provide a containerized version of SCP Secret Lab that can be easily started on many different hosting platforms with minimal configuration required

Requires docker-compose installed to use the docker-compose file for running

# To run with docker

MOUNT_POINT=/mount/path/here docker-compose up -d


# Contributing
Pull requests with updated or alternate dockerfile(s), compose files, or implementation tips are absolutely encouraged

Details on how to install servermod plugins with this container, or experiences with various hosting providers would also be appreciated

# Coming soon
Container version designed for being run on AWS

Instructions on how to install docker and deploying this container on a hosting provider

# Notes
Plugin dll's can most likely installed by placing them in /home/scp/scp_server/sm_plugins


Edits to the dockerfile with something similiar to git-clone --bare to grab these plugins could allow for seamless and automatic installation of plugins
