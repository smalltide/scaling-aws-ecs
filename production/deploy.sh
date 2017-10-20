#!/usr/bin/env bash

# //////////////////////////////////////////////////////////////////////////////
# This script's purpose is to let you automatically deploy the Ruby on Rails
# demo application provided in this course.
#
# It is meant to be pretty general purpose, but you will likely want to make a
# few edits to customize it for your application or framework's needs.
#
# It is expected that you will at least configure your application by configuring
# the variables below this comment block.
#
# You may also want to adjust a few of the functions to customize them for your
# application. I needed to make a judgment call to balance out making the script
# somewhat general purpose and easy to understand without being a bash wizard.
# //////////////////////////////////////////////////////////////////////////////

# Exit the script as soon as something fails.
set -e

# What is the application's path?
APPLICATION_PATH="."

# How is the application defined in your docker-compose.yml file?
APPLICATION_NAME="dockerzon"

# What is the Docker image's name?
IMAGE="dockerzon_dockerzon"

# What is your Docker registry's URL?
REGISTRY="282921537141.dkr.ecr.ap-northeast-1.amazonaws.com"

# What is the repository's name?
REPO="dockerzon/dockerzon"

# Which build are you pushing?
BUILD="latest"

# Which cluster are you acting on?
CLUSTER="production"

# //////////////////////////////////////////////////////////////////////////////
# Optional steps that you may want to implement on your own!
# ------------------------------------------------------------------------------
# Run the application's test suite to ensure you always push working builds.
# Push your code to a remote source control management service such as GitHub.
# //////////////////////////////////////////////////////////////////////////////

function push_to_registry () {
  # Move into the application's path and build the Docker image.
  cd "${APPLICATION_PATH}" && docker-compose build "${APPLICATION_NAME}" && cd -

  docker tag "${IMAGE}:${BUILD}" "${REGISTRY}/${REPO}:${BUILD}"

  # Automatically refresh the authentication token with ECR.
  eval "$(aws ecr get-login --no-include-email)"

  docker push "${REGISTRY}/${REPO}"
}

function update_web_service () {
  aws ecs register-task-definition \
    --cli-input-json file://web-task-definition.json
  aws ecs update-service --cluster "${CLUSTER}" --service web \
    --task-definition web --desired-count 2
}

function update_worker_service () {
  aws ecs register-task-definition \
    --cli-input-json file://worker-task-definition.json
  aws ecs update-service --cluster "${CLUSTER}" --service worker \
    --task-definition worker --desired-count 1
}

function run_database_migration () {
  aws ecs run-task --cluster "${CLUSTER}" --task-definition db-migrate --count 1
}

function all_but_migrate () {
  # Call the other functions directly, but skip migrating simply because you
  # should get used to running migrations as a separate task.
  push_to_registry
  update_web_service
  update_worker_service
}

function help_menu () {
cat << EOF
Usage: ${0} (-h | -p | -w | -r | -d | -a)

OPTIONS:
   -h|--help             Show this message
   -p|--push-to-registry Push the web application to your private registry
   -w|--update-web       Update the web application
   -r|--update-worker    Update the background worker
   -d|--run-db-migrate   Run a database migration
   -a|--all-but-migrate  Do everything except migrate the database

EXAMPLES:
   Push the web application to your private registry:
        $ ./deploy.sh -p

   Update the web application:
        $ ./deploy.sh -w

   Update the background worker:
        $ ./deploy.sh -r

   Run a database migration:
        $ ./deploy.sh -d

   Do everything except run a database migration:
        $ ./deploy.sh -a

EOF
}

# Deal with command line flags.
while [[ $# > 0 ]]
do
case "${1}" in
  -p|--push-to-registry)
  push_to_registry
  shift
  ;;
  -w|--update-web)
  update_web_service
  shift
  ;;
  -r|--update-worker)
  update_worker_service
  shift
  ;;
  -d|--run-db-migrate)
  run_database_migration
  shift
  ;;
  -a|--all-but-migrate)
  all_but_migrate
  shift
  ;;
  -h|--help)
  help_menu
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  ;;
esac
shift
done
