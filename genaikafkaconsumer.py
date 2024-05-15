from cgi import print_arguments
from kafka import KafkaConsumer, KafkaProducer
from openai import OpenAI
import json
import os
import sys

OPENAIKEY = os.environ["OPENAI_API_KEY"]
if not OPENAIKEY:
    raise ValueError("OPENAI_API_KEY environment variable is not set")
client = OpenAI(api_key=OPENAIKEY)

# Arguments passed to the script
totalargs = len(sys.argv)
#print(sys.argv)
deployment = sys.argv[1]
bootstrap = sys.argv[2]
if totalargs == 5:
    apikey = sys.argv[3]
    apisecret = sys.argv[4]

if totalargs == 3:
    # Kafka consumer setup for CP
    consumer = KafkaConsumer(
        'support-tickets',
        bootstrap_servers=bootstrap,
        auto_offset_reset='latest',
        group_id='group-support-tickets'
    )
    # Producer for CP
    producer = KafkaProducer(
    bootstrap_servers=bootstrap,  # List of Kafka broker addresses
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serializer for the message data
    )

elif totalargs == 5:
    consumer = KafkaConsumer(
        'support-tickets',
        bootstrap_servers=bootstrap,
        security_protocol='SASL_SSL',
        sasl_mechanism='PLAIN',
        sasl_plain_username=apikey,
        sasl_plain_password=apisecret,
        auto_offset_reset='latest',
        group_id='group-support-tickets'
    )
    # Producer for CCloud
    producer = KafkaProducer(
        bootstrap_servers=bootstrap,  # List of Kafka broker addresses
        security_protocol='SASL_SSL',
        sasl_mechanism='PLAIN',
        sasl_plain_username=apikey,
        sasl_plain_password=apisecret,
        value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serializer for the message data
    )

# Define the topic name
topic = 'support-ticket-actions'

def process_with_ai(message):
    try:
        # generate Actions via AI
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
                messages=[ { "role": "system","content": "Summarize this customer feedback and suggest an actionable insight"},
                           { "role": "user", "content": message}
                ],
                temperature=0.7,
                max_tokens=64,
                top_p=1
        )
        return response.choices[0].message.content
    except Exception as e:
        print(f"Error processing message with AI: {e}")
        return None

def main():
    try:
        for message in consumer:
            msg_value = message.value.decode('utf-8')
            print(f"**** MESSAGE FROM ZENDESK ****")
            print(f"Received message: {msg_value}")
            ai_output = process_with_ai(msg_value)
        
            if ai_output:
                print(f"**** AI OUTPUT ****")
                print(f"AI processed output: {ai_output}")
                
                # Produce to support-ticket-actions
                producer.send(topic, ai_output)
                producer.flush()
                
                print("Message sent successfully to topic support-ticket-summaries!")
            else:
                print("Failed to process message with AI.")
    except Exception as e:
         print(f"Error occurred: {e}")
    finally:
        producer.close()
        
if __name__ == "__main__":
    main()  