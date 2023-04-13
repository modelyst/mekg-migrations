#!/bin/bash

MPS_DOWNLOAD_LINK=https://data.caltech.edu/records/hjfx4-a8r81/files/public_release_20230228.tar.gz?download=1
MEKG_DOWNLOAD_LINK=https://data.caltech.edu/records/h88fq-dk449/files/public-release-neo4j-20230228.dump?download=1

# Define the output path for the downloaded data
SCRIPT_DIR="$(dirname "$0")"
OUTPUT_PATH=$(realpath $SCRIPT_DIR/../data)
# Make the required directories
mkdir -p $OUTPUT_PATH/releases/postgres
mkdir -p $OUTPUT_PATH/releases/neo4j

# Define a usage function that displays the correct usage of the script
usage() {
  echo "Usage: $0 [-n|--neo4j] [-p|--postgresql]" >&2
  exit 1
}


# Define a function to download the PostgreSQL release from Caltech data
download_postgresql() {
  echo "Downloading Postgres Release from Caltech data..."
  mkdir -p $OUTPUT_PATH/postgres
  wget $MPS_DOWNLOAD_LINK -O $OUTPUT_PATH/postgres/public_release.tar.gz
  echo "Downloaded Postgres Release from Caltech data"
}

# Define a function to download the Neo4j release from S3
download_neo4j() {
  echo "Downloading Neo4j release from Caltech data..."
  mkdir -p $OUTPUT_PATH/neo4j
  PROFILE=${PROFILE:-default}
  wget $MEKG_DOWNLOAD_LINK -O $OUTPUT_PATH/neo4j/neo4j.dump
  echo "Downloaded Neo4j release from Caltech data"
}

# Check if there are any command line arguments
if [[ $# -eq 0 ]]; then
  usage
fi

# Loop through each command line argument
while [[ $# -gt 0 ]]; do
  key="$1"

  # Check which option was specified
  case $key in
    -n|--neo4j)
      download_neo4j
      shift
      ;;
    -p|--postgresql)
      download_postgresql
      shift
      ;;
    *)
      usage
      ;;
  esac
done
