#!/bin/bash

# Set default values for Neo4j variables
NEO4J_COMMAND=${NEO4J_COMMAND:-"neo4j-admin"}
SCHEMA=${SCHEMA:-'public_release'}
OUTPUT_DIR=${OUTPUT_DIR:-'../../data/pg4j_output'}

# Check if NEO4J_ID is set and update Neo4j variables if it is
if [ ! -z "$NEO4J_ID" ]; then
    NEO4J_DESKTOP="${HOME}/.config/Neo4j\\ Desktop/Application/relate-data/dbmss"
    NEO4J_HOME="${NEO4J_DESKTOP}/dbms-${NEO4J_ID}"
    NEO4J_COMMAND="${NEO4J_HOME}/bin/neo4j-admin"
    echo "Using Neo4j Desktop and setting command to: ${NEO4J_COMMAND}"
fi

# Get the directory of the current script   
DIR=$(dirname "$0")

set -e

# Define functions for dump and import commands
function dump_data {
    # Create directories for edge and node SQL files
    mkdir -p $DIR/sql/edges
    mkdir -p $DIR/sql/nodes
    mkdir -p $OUTPUT_DIR
    
    # Replace schema name in SQL template files and write them to the SQL directory
    for sql_template_file in $DIR/sql_templates/edges/*; do
        sed "s/\"SCHEMA\"/\"$SCHEMA\"/g" "$sql_template_file" > "$DIR/sql/edges/$(basename "$sql_template_file")"
    done
    
    for sql_template_file in $DIR/sql_templates/nodes/*; do
        sed "s/\"SCHEMA\"/\"$SCHEMA\"/g" "$sql_template_file" > "$DIR/sql/nodes/$(basename "$sql_template_file")"
    done
    
    # Dump data from PostgreSQL database
    echo "Dumping data from PostgreSQL database..."
    python -m pg4j dump \
        --schema $SCHEMA \
        --config $DIR/docker.env \
        --output $OUTPUT_DIR \
        --mapping-input $DIR/caltech.yaml \
        --read \
        --sql $DIR/sql \
        --overwrite
    
    # Log success message
    echo "Dump completed successfully."
}

function import_data {
    # Check if pg4j output directory exists
    if [ ! -d "$OUTPUT_DIR" ]; then
        echo "Error: pg4j output directory not found. Please run the dump command first."
        exit 1
    fi

    # Import data into Neo4j
    echo "Importing data into Neo4j..."
    python -m pg4j import \
        --data-dir $OUTPUT_DIR \
        --overwrite \
        --id-type STRING \
        --command "$NEO4J_COMMAND" \
        --neo4j-home "$NEO4J_HOME"
    
    # Log success message
    echo "Import completed successfully."
}

function neo4j_dump {
    # Dump data from Neo4j
    echo "Dumping data from Neo4j..."
    echo $NEO4J_COMMAND
    eval $NEO4J_COMMAND database dump  \
        neo4j \
        --overwrite-destination=true \
        --to-path=$DIR/../../data/releases/neo4j
}

# Parse command-line arguments
case "$1" in
    dump)
        dump_data
        ;;
    import)
        import_data
        ;;
    neo4j_dump)
        neo4j_dump
        ;;
    *)
        echo "Usage: $0 {dump|import}"
        exit 1
        ;;
esac
