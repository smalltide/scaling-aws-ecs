#!/usr/bin/env bash

# Exit the script as soon as something fails.
set -e

# What is the backend's name and port? The backend should be the name of the
# Docker image that is linked to nginx.
PLACEHOLDER_BACKEND_NAME="dockerzon"
PLACEHOLDER_BACKEND_PORT="8000"

# What should the virtualhost's name be? This is the server_name value and would
# typically be your EC2 instance's public DNS name if you're using an elastic
# load balancer. If you did not have an ELB then you would set it to your domain
# name, such as foo.com.
#
# It defaults to the AWS EC2 Public DNS address by pulling this info from EC2's
# metadata. This allows us to dynamically configure nginx at runtime.
#
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
PLACEHOLDER_VHOST="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"
#PLACEHOLDER_VHOST="127.0.0.1"


# Where is our default config located?
DEFAULT_CONFIG_PATH="/etc/nginx/conf.d/default.conf"

# Replace all instances of the placeholders with the values above.
sed -i "s/PLACEHOLDER_VHOST/${PLACEHOLDER_VHOST}/g" "${DEFAULT_CONFIG_PATH}"
sed -i "s/PLACEHOLDER_BACKEND_NAME/${PLACEHOLDER_BACKEND_NAME}/g" "${DEFAULT_CONFIG_PATH}"
sed -i "s/PLACEHOLDER_BACKEND_PORT/${PLACEHOLDER_BACKEND_PORT}/g" "${DEFAULT_CONFIG_PATH}"

# Execute the CMD from the Dockerfile and pass in all of its arguments.
exec "$@"
