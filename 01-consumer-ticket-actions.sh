#!/bin/bash
export BOOTSTRAP=$(awk '/endpoint:/{print $NF}' bootstrap)
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Consume from support-ticket-actions topic\007"'
echo -e "\033];Consume from support-ticket-actions topic\007"

# Consume raw events Terminal 1kafka-console-consumer --bootstrap-server  localhost:9092 --topic support-ticket-summaries
echo "Consume from support-ticket-actions topic: "
kafka-console-consumer --bootstrap-server $BOOTSTRAP --topic support-ticket-actions --consumer.config kafkatools.properties
