#!/bin/bash

# cmd-space-delta.sh
# This removes obsolete tags in image groups from Docker Registry,
# and reports disk space before and after.
# USAGE: 
#   curl -O https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/bash/cmd-space-delta.sh
#   chmod +x cmd-space-delta.sh.sh
#   ./cmd-space-delta.sh ~/var/log
# RESPONSE:
#   38M   /var/log

# This is https://github.com/wilsonmar/DevSecOps/blob/master/bash/cmd-space-delta.sh
# Adapted from https://unix.stackexchange.com/questions/53841/how-to-use-a-timer-in-bash
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/bash/cmd-space-delta.sh)"

# This is free software; see the source for copying conditions. There is NO
# warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


### 0. Set display utilities:

# clear  # screen and history?

set -euo pipefail  # -x to show commands.

# Capture starting timestamp:
start=$(date +%s)

### Set color variables (based on aws_code_deploy.sh): 
bold="\e[1m"
dim="\e[2m"
underline="\e[4m"
blink="\e[5m"
reset="\e[0m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"

h2() {
  printf "\n${bold}>>> %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
info() {
  printf "${dim}➜ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
success() {
  printf "${green}✔ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
error() {
  printf "${red}${bold}✖ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
warnError() {
  printf "${red}✖ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
warnNotice() {
  printf "${blue}✖ %s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}
note() {
  printf "\n${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$(echo "$@" | sed '/./,$!d')"
}

# Check if argument is provided and folder exists ..."
if [ $# -ne 1 ]; then
   error "Please provide an argument: EXAMPLE: ./cmd-space-delta.sh  ~/Documents"
   exit 
else  # got it:
  if [ ! -d "$1" ]; then  # not in pwd:
     error "Folder $1 not found. Exiting..."
     exit 
  fi
fi



# Define pre-requisite utility functions:"
command_exists() {  # in /usr/local/bin/... if installed by brew
  command -v "$@" > /dev/null 2>&1
}

if [ ! -f "folder.space.sh" ]; then  # not in pwd:
   curl -O https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/bash/folder-space.sh
fi


h2 "STEP 1 - Authenticate and inspect if account/image/tag has already been removed..."
# curl  oauth
# ??? Error Message: "account/image/tag already deleted"


h2 "STEP 2 - Obtain starting space: "
chmod +x folder-space.sh
source folder-pace.sh  $1  START_BYTES


exit  ###############


h2 "STEP 3 - Get account/image:tag SHA"
# OH_SHA=$( docker inspect dev-registry-1x01.amdc.mckinsey.com:5000/pythonapi:9254c0d )
# MY_SHA=jq ??? "$OH_SHA"


# What operating system:

# Install jq
# If centos or RHEL:
#   yum install -y epel-release
#   yum install -y jq

   # Otherwise
   #   wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
   #   chmod +x ./jq
   #   cp jq /usr/bin


h2 "STEP 4 - Verify version of Docker Registry ..."
# note "No releases in https://github.com/docker/distribution/tree/master/registry"
# docker registry  ???


h2 "STEP 5 - Count accounts, images, tags ..."
echo "call Python ???"


h2 "STEP 6 - Remove layers ..."
# Do one:
   # curl -v -X DELETE "https://my.docker.registry.com:5000/v2/mytestdockerrepro/manifests/$MY_SHA" )
      # Expect 202 good response



#h2 "STEP 5 - Obtain space after removing layers (should be same):"
#./folder.space.sh  $1  MID_BYTES


h2 "STEP 7 - Garbage collection to reclaim disk space ..."
# docker exe registry bin/registry garbage-collect --dry-run /etc/docker/registry/config.yml


h2 "STEP 8 - Count accounts, images, tags ..."
echo "call Python ???"


h2 "STEP 9 - Calculate space delta ..."
source folder.space.sh  $1  END_BYTES 
START_BYTES=$(<.START_BYTES)
END_BYTES=$(<.END_BYTES)
DIFF_BYTES=$( echo "$END_BYTES - $START_BYTES" | bc )
echo "END_BYTES=$END_BYTES - START_BYTES $START_BYTES = $DIFF_BYTES"


h2 "STEP 10 - De-gas storage units to reduce fragmentation ..."
# ???


h2 "STEP 11 - Obtain final space ..."
source folder.space.sh  $1  FINAL_BYTES 
#START_BYTES=$(<.START_BYTES)
FINISH_BYTES=$(<.FINISH_BYTES)
DIFF_BYTES=$( echo "$FINISH_BYTES - $START_BYTES" | bc )
success "FINISH_BYTES=$FINISH_BYTES - START_BYTES $START_BYTES = $DIFF_BYTES"

# Capture ending timestamp and Calculate difference:
   end=$(date +%s)
   beg-seconds=$(echo "$end - $start" | bc )
   #echo $seconds' sec'
   info 'Elapsed HH:MM:SS: ' $( awk -v t=$beg-seconds 'BEGIN{t=int(t*1000); printf "%d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' )

