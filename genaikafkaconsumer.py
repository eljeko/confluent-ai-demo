from kafka import KafkaConsumer, KafkaProducer
from openai import OpenAI
import json
import os

OPENAIKEY = os.environ["OPENAI_API_KEY"]
if not OPENAIKEY:
    raise ValueError("OPENAI_API_KEY environment variable is not set")
client = OpenAI(api_key=OPENAIKEY)

# Kafka consumer setup
consumer = KafkaConsumer(
    'support-tickets',
    bootstrap_servers=['localhost:9092'],
    auto_offset_reset='latest',
    group_id='group-support-tickets'
)

# Kafka Producer setup
producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],  # List of Kafka broker addresses
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