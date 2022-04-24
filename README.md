# GameManagement
Building something to help manage servers that I play games on with friends while minimizing cost

CAUTION: This project is both a work in progress, and not intended to be widely used. I maintain this in my free time in between gaming with my 
friends. Feel free to use any of the code, but I make no guarentees on quality or security.

## Purpose
The idea behind this project is to be able to with minimal effort spin up a new game server that has persistant storage and DNS so that people
can convieniantly play together, while also allowing people to shut the game server down while not in use to minimize cost.

## How it works
Game servers are defined by Dockerfiles, they may be built by other people but will be hosted externally to this project. Games are defined in `main.tf`
where the docker command, and networking config is defined. the Game module will automatically provision a VM (google compute engine) as well as some 
web endpoints (google cloud functions) that will be able to turn the instance on and off.
