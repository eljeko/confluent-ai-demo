#!/bin/bash
export DEPLOYMENT=$(awk '/deployment:/{print $NF}' deployment)
export BOOTSTRAP=$(awk '/endpoint:/{print $NF}' bootstrap)
export APIKEY=$(awk '/api_key:/{print $NF}' apikey)
export APISECRET=$(awk '/api_secret:/{print $NF}' apikey)

# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Start genAIKafkaConsumer Client\007"'
echo -e "\033];Consume from support-tickets topic\007"

# Consume raw events Terminal 1
echo "Consume from support-tickets topic (langchain LLM AI): "
source env-vars

if [[ "$DEPLOYMENT" == "CP" ]] ; then
    echo "Start genAIKafkaConsumer with Confluent Platform"
    python3 genaikafkaconsumer.py $DEPLOYMENT $BOOTSTRAP
elif [[ "$DEPLOYMENT" == "CC" ]] ; then
    echo "Start genAIKafkaConsumer with Confluent Cloud"
    python3 genaikafkaconsumer.py $DEPLOYMENT $BOOTSTRAP $APIKEY $APISECRET
fi

