#!/bin/bash
export DEPLOYMENT=$(awk '/deployment:/{print $NF}' deployment)
export BOOTSTRAP=$(awk '/endpoint:/{print $NF}' bootstrap)

if [[ "$DEPLOYMENT" == "CP" ]] ; then
    # Delete topics
    kafka-topics --delete --topic support-tickets --bootstrap-server $BOOTSTRAP
    kafka-topics --delete --topic support-ticket-actions --bootstrap-server $BOOTSTRAP
    # Stop CP
    confluent local services stop
    # Destroy CP
    confluent local destroy
elif [[ "$DEPLOYMENT" == "CC" ]] ; then
    export APIKEY=$(awk '/api_key:/{print $NF}' apikey)
    export APISECRET=$(awk '/api_secret:/{print $NF}' apikey)
    export ENVID=$(awk '/id:/{print $NF}' envid)
    export CLUSTERID=$(awk '/id:/{print $NF}' clusterid)
    # DELETE topics
    confluent kafka topic delete support-tickets --cluster $CLUSTERID --environment $ENVID --force
    confluent kafka topic delete support-ticket-actions --cluster $CLUSTERID --environment $ENVID --force
    # DELETE API Key
    confluent api-key delete  $APIKEY --force
    # delete cluster
    confluent kafka cluster delete $CLUSTERID --environment $ENVID --force
    # Delete environment
    confluent environment delete  $ENVID --force 
fi

# Delete files
if [[ "$DEPLOYMENT" == "CC" ]] ; then
    rm apikey
    rm envid
    rm clusterid
    rm poolid
fi
rm bootstrap
rm basedir
rm deployment
rm kafkatools.properties

echo "Demo stopped and deleted."
