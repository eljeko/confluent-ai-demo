#!/bin/bash
# **************************
# Simple genAI Kafka Consumer demo start script, running with Confluent Platform or Confluent Cloud
# Parameter CP: You will start with Confluent Platform installed on your desk
# Paramater CC: You will start with Confluent Cloud and Confluent CLI installed
# Usage:
# ./00_start_genAIKafkaConsumerDemo.sh CP | CC
# ***************************


# pre-reqs
# confluent cli installed
# running Java at least 1.8 (till CP 8.0 is it supported) or newer
# Confluent Platform 7.6. or newer installed
# Python3 with following packages installed: kafka and openai

pwd > basedir
export BASEDIR=$(cat basedir)

if [[ $# -eq 0 ]] ; then
    echo "Usage: ./00_start_genAIKafkaConsumerDemo.sh CP | CC"
    exit 0
fi

case "$1" in
    CP) echo "Demo will be prepared with Confluent Platform" ;;
    CC) echo "Demo will be prepared with Confluent Cloud" ;;
    *) echo "Your parameter is not supported. Usage: ./00_start_genAIKafkaConsumerDemo.sh CP | CC" ; exit 0;
esac

source env-vars

if [[ "$1" == "CP" ]] ; then
    echo "Start Demo with Confluent Platform"
    echo "deployment: CP" > deployment
    # I am running Confluent Platform 7.6, start local platform
    confluent local services start
    echo "endpoint: localhost:9092" > bootstrap
    export BOOTSTRAP=localhost:9092
    # Create Topics
    kafka-topics --create --topic support-tickets --bootstrap-server localhost:9092 
    kafka-topics --create --topic support-ticket-actions --bootstrap-server localhost:9092 
    # Create kafka tool config file
    echo "# Required connection configs for Kafka producer, consumer, and admin
    bootstrap.servers=$BOOTSTRAP
    # Required for correctness in Apache Kafka clients prior to 2.6
    client.dns.lookup=use_all_dns_ips
    # Best practice for higher availability in Apache Kafka clients prior to 3.0
    session.timeout.ms=45000
    # Best practice for Kafka producer to prevent data loss
    acks=all" >  kafkatools.properties
elif [[ "$1" == "CC" ]] ; then
    echo "Start Demo with Confluent Cloud"
    echo "deployment: CC" > deployment
    # I am running Confluent Cloud, start local platform
    confluent login
    # Create environment
    confluent environment create $ENVIRONMENTNAME --governance-package essentials -o yaml > envid
    export ENVID=$(awk '/id:/{print $NF}' envid)
    # create cluster
    confluent kafka cluster create cmgenAI --cloud gcp --environment $ENVID --region europe-west1 -o yaml > clusterid
    export CLUSTERID=$(awk '/id:/{print $NF}' clusterid)
    export BOOTSTRAP=$(awk '/endpoint: SASL_SSL:\/\//{print $NF}' clusterid | cut -d ":" -f2- | cut -d "/" -f2- | cut -d "/" -f2-)
    echo "endpoint: $BOOTSTRAP" > bootstrap
    # create topics
    confluent kafka topic create support-tickets --partitions 1 --cluster $CLUSTERID --environment $ENVID
    confluent kafka topic create support-ticket-actions --partitions 1 --cluster $CLUSTERID --environment $ENVID
    # Create API Key
    confluent api-key create --description "API Key for genai Demo" --resource $CLUSTERID --environment $ENVID -o yaml > apikey
    export APIKEY=$(awk '/api_key:/{print $NF}' apikey)
    export APISECRET=$(awk '/api_secret:/{print $NF}' apikey)
    # Create Client Config for Kafka Tools
    echo "# Required connection configs for Kafka producer, consumer, and admin
    bootstrap.servers=$BOOTSTRAP
    security.protocol=SASL_SSL
    sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username='$APIKEY' password='$APISECRET';
    sasl.mechanism=PLAIN
    # Required for correctness in Apache Kafka clients prior to 2.6
    client.dns.lookup=use_all_dns_ips
    # Best practice for higher availability in Apache Kafka clients prior to 3.0
    session.timeout.ms=45000
    # Best practice for Kafka producer to prevent data loss
    acks=all" >  kafkatools.properties
fi 

# Start iterm Demo
# Start Terminal
echo ""
echo "Start Clients from demo...."
open -a iterm
sleep 10
osascript 01_terminals.scpt $BASEDIR

echo "Demo started"

