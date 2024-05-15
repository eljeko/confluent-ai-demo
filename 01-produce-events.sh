#!/bin/bash
export BOOTSTRAP=$(awk '/endpoint:/{print $NF}' bootstrap)
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Produce to support-tickets topic\007"'
echo -e "\033];Produce to support-tickets topic\007"

# Produce to support-ticket topic Terminal 1
echo "Produce to support-tickets topic: "
echo "Sample Data is ...."
echo "1 ==> Really enjoyed the new update on the app! But I found it a bit difficult to navigate to my profile settings. Maybe it could be made more intuitive?"
echo "2 ==> I really like the Meet the Expert sessions around Confluent new features and best practices. We are facing problems around Replicator and to replicate data between cluster with RBAC and mtls setup. Can you advice?"
echo "3 ==> The Confluent Software does not work. I try to create a Cloud Bridge with cluster linking from my on-prem cluster to confluent cloud cluster, and this not working."
echo " "
echo "Now produce data samples..."
echo " "
kafka-console-producer --bootstrap-server $BOOTSTRAP --topic support-tickets --producer.config kafkatools.properties