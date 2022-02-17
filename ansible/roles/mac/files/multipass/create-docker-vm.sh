#!/usr/bin/env bash

###
# Creates a Multipass VM to host docker as a Docker Desktop replacement
#
# See https://dev.to/benmatselby/use-docker-context-to-switch-between-different-solutions-3e0b
##

# Set the config of the Multipass VM from environment variables or use defaults.
cpu_count=${MULTIPASS_CPU_COUNT:-4}
memory=${MULTIPASS_MEMORY:-4G}
disk_space=${MULTIPASS_DISK_SPACE:-40G}
ubuntu_version=${MULTIPASS_UBUNTU_VERSION:-20.04}
instance_name=${MULTIPASS_INSTANCE_NAME:-docker-multipass}

echo '---------------------------------------'
echo "CPU count       - ${cpu_count}"
echo "Memory          - ${memory}"
echo "Disk space      - ${disk_space}"
echo "Ubuntu version  - ${ubuntu_version}"
echo "Instance name   - ${instance_name}"
echo '---------------------------------------'
echo ''

# Remove the existing Multipass instance
echo "Removing existing Multipass instance..."
multipass delete "${instance_name}"
multipass purge

# Spin up the Multipass instance
echo "Launching new Multipass instance..."
multipass launch -c "${cpu_count}" -m "${memory}" -d "${disk_space}" -n "${instance_name}" "${ubuntu_version}" --cloud-init docker.yml

# Mount some local folders to make life a little easier
echo "Mounting some local folders..."
multipass mount /Users "${instance_name}"
multipass mount /Volumes "${instance_name}"

# Setup a docker context for Multipass
echo "Create docker context for Multipass..."
docker context create multipass \
  --description "Multipass Docker Desktop" \
  --docker "host=ssh://ubuntu@${instance_name}.local"

# Set Multipass as default docker context
echo "Set Multipass docker context as default..."
docker context use multipass

echo ""
echo "SSH into the VM to accept the authenticity of the host:"
echo "ssh ubuntu@${instance_name}.local"
