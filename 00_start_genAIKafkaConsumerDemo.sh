#!/bin/bash

# pre-reqs
# confluent cli installed
# running Java at least 1.8 (till CP 8.0 is it supported) or newer
# Confluent Platform 7.6. or newer installed
# Python3 with following packages installed: kafka and openai

pwd > basedir
export BASEDIR=$(cat basedir)

source env-vars

# I am running Confluent Platform 7.6, start local platform
confluent local services start

# Create Topics
kafka-topics --create --topic support-tickets --bootstrap-server localhost:9092 
kafka-topics --create --topic support-ticket-actions --bootstrap-server localhost:9092 

# Start iterm Demo
# Start Terminal
echo ""
echo "Start Clients from demo...."
open -a iterm
sleep 10
osascript 01_terminals.scpt $BASEDIR

