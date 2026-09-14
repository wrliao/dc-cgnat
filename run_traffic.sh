#!/bin/bash

# Initialize variables
PROJ_NAME=""
TENANT_NAME=""
NUM_HOSTS=""
TEST_TYPE=""

# 1. Parse command-line arguments using getopts
while getopts "c:h:I:t:" opt; do
  case $opt in
    c) PROJ_NAME="$OPTARG" ;;
    h) TENANT_NAME="$OPTARG" ;;
    I) NUM_HOSTS="$OPTARG" ;;
    t) TEST_TYPE="$OPTARG" ;;
    \?) echo "Usage: $0 [-c <project_name>] [-h <tenant_name>] [-I <num_hosts>] [-t <icmp|http>]" >&2
        exit 1 ;;
  esac
done

# 2. Interactive fallback for missing arguments
if [ -z "$PROJ_NAME" ] || [ -z "$TENANT_NAME" ] || [ -z "$NUM_HOSTS" ] || [ -z "$TEST_TYPE" ]; then
    echo "========================================"
    echo " Interactive Mode"
    echo "========================================"
fi

if [ -z "$PROJ_NAME" ]; then
    read -p "Enter Containerlab Project Name [default: clab-dc-cgnat]: " input
    PROJ_NAME=${input:-clab-dc-cgnat}
fi

if [ -z "$TENANT_NAME" ]; then
    read -p "Enter Tenant Name (e.g., tenant1, tenant2): " TENANT_NAME
fi

if [ -z "$NUM_HOSTS" ]; then
    read -p "Enter Number of Hosts per Tenant (e.g., 250): " NUM_HOSTS
fi

if [ -z "$TEST_TYPE" ]; then
    read -p "Enter Traffic Type (icmp or http): " TEST_TYPE
fi

# 3. Final Validation
if [ -z "$TENANT_NAME" ] || [ -z "$NUM_HOSTS" ] || [ -z "$TEST_TYPE" ]; then
    echo "Error: All fields are required."
    exit 1
fi

if [[ "$TEST_TYPE" != "icmp" && "$TEST_TYPE" != "http" ]]; then
    echo "Error: Invalid traffic type '${TEST_TYPE}'. Must be 'icmp' or 'http'."
    exit 1
fi

# 4. Define container names and config files based on inputs
INTERNET_HOST_NAME="internet-host"
HOST_CONTAINER="${PROJ_NAME}-${INTERNET_HOST_NAME}"
TENANT_CONTAINER="${PROJ_NAME}-${TENANT_NAME}"

HOST_CONFIG="${INTERNET_HOST_NAME}_${TEST_TYPE}.json"
TENANT_CONFIG="${TENANT_NAME}_${TEST_TYPE}.json"

echo ""
echo "========================================"
echo " Starting BNG Blaster Test"
echo " Project Name     : ${PROJ_NAME}"
echo " Tenant Container : ${TENANT_CONTAINER}"
echo " Host Container   : ${HOST_CONTAINER}"
echo " Traffic Type     : ${TEST_TYPE}"
echo " Num Hosts        : ${NUM_HOSTS}"
echo " Config File      : ${TENANT_CONFIG}"
echo "========================================"

# 5. Start the internet-host process FIRST
echo "[INFO] Starting ${TEST_TYPE} server on ${HOST_CONTAINER} (in background)..."
docker exec -d -w /bngblaster "${HOST_CONTAINER}" bngblaster -C "${HOST_CONFIG}"

# Give the server 2 seconds to fully initialize
sleep 2

# 6. Start the tenant process SECOND
echo "[INFO] Starting ${TEST_TYPE} client on ${TENANT_CONTAINER}..."
# Maps script's NUM_HOSTS to bngblaster's -c flag, and appends the interactive UI flag (-I)
docker exec -it -w /bngblaster "${TENANT_CONTAINER}" bngblaster -C "${TENANT_CONFIG}" -c "${NUM_HOSTS}" -I

# 7. Cleanup after tenant process ends (when you exit UI)
echo "[INFO] Test finished. Cleaning up internet-host process..."
docker exec "${HOST_CONTAINER}" pkill bngblaster

echo "[INFO] Done."
