#!/bin/bash
# Set title
export PROMPT_COMMAND='echo -ne "\033]0;Start genAIKafkaConsumer Client\007"'
echo -e "\033];Consume from support-tickets topic\007"

# Consume raw events Terminal 1
echo "Consume from support-tickets topic (langchain LLM AI): "
source env-vars
python3 genaikafkaconsumer.py