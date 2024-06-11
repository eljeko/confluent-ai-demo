#!/bin/bash
export ENVID=$(awk '/id:/{print $NF}' envid)
export CLUSTERID=$(awk '/id:/{print $NF}' clusterid)
export FPOOLID=$(awk '/id:/{print $NF}' poolid)

# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Flink SQL Shell\007"'
echo -e "\033];Flink SQL Shell\007"

echo "Start Flink SQL Shell: "
confluent flink shell --compute-pool $FPOOLID --database $CLUSTERID --environment $ENVID
