#!/bin/bash

# Delete topics
kafka-topics --delete --topic support-tickets --bootstrap-server localhost:9092 
kafka-topics --delete --topic support-ticket-actions --bootstrap-server localhost:9092 

# Stop CP
confluent local services stop
# Destroy CP
confluent local destroy

# Delete files
rm basedir

echo "Demo stopped and deleted."
