# Generic and simple generative AI sample with Confluent: Say hello to the `genAIKafkaConsumer` APP

This is another demo app around generative AI and Confluent. The demo is pretty nice, easy to read and simple demo written in Python.
Generative AI and Confluent/Apache Kafka are powerful technologies that, when combined, can revolutionize data-driven industries by enhancing real-time data processing with intelligent, automated insights. 

The use case is also pretty nice. We have a need to combine real-time, because they are highly critical, with the power of genAI to fasten the process. We run a [Zendesk Sourcer Connector](https://docs.confluent.io/kafka-connectors/zendesk/current/overview.html) and ingest P1 support tickets into Confluent Platform cluster. We route this ticket to openAI API and ask for formulate actions out of this ticket and route it directly to the P1 Dashboard and Support Engineers. This amazing and simple value add brings much benefits into the P1 ticket handling.

The prompt is very easy and straight forward: `Summarize this customer ticket feedback and suggest an actionable insight`.
The next image show the demo architecture. 
![Demo architecture.](img/ConfluentGenAIKafkaConsumer.png)

The Zendesk Connector is simulated with a simple Kafka producer. I put three sample Tickets into the producer client:

* 1 ==> Really enjoyed the new update on the app! But I found it a bit difficult to navigate to my profile settings. Maybe it could be made more intuitive?
* 2 ==> I really like the Meet the Expert sessions around Confluent new features and best practices. We are facing problems around Replicator and to replicate data between cluster with RBAC and mtls setup. Can you advice?
* 3 ==> The Confluent Software does not work. I try to create a Cloud Bridge with cluster linking from my on-prem cluster to confluent cloud cluster, and this not working.

Take them and produce each message to `support-tickets` topic or use your own ideas. Based on this ticket content openAI is doing a summary and suggest an actionable insight.

As you will see this is really pretty easy and brings much value.

## Starting the Demo.

prerequisite:

* confluent cli installed
* running Java at least 1.8 (till CP 8.0 JDK 1.8 is supported) or newer
* Confluent Platform 7.6. or newer installed
* Python3 with following packages installed: kafka and openai
* iterm2 installed (if not installed, run the scripts manually, check script `01_terminals.scpt`)
* I run on INTEL MacOS
* Having an OpenAI Api Key. If not, create an OpenAI API Key (follow [open AI Account setup](https://platform.openai.com/docs/quickstart/account-setup?context=python))

copy the OpenAI Key to `env-vars` file:

```Bash
at > $PWD/env-vars <<EOF
export OPENAI_API_KEY=YOUR openAI Key
EOF
```

Start the demo by executing:

```bash
./00_start_genAIKafkaConsumerDemo.sh
```

This will open iterm. You can now play around and produce some messages and see what openAI will generate.
![Demo .](img/demo.png)

* First Window Session: The Zendesk Ticket producer: Copy text and press enter
* Second Window Session: Show the genAIKafkaConsumer in action
* Third Window Session: A consumer on topic support.ticket-actions will show what openAI did generate

All results will then produce into the topic `support-ticket-actions`. see Control Center Screenshot:

![Control Center](img/c3.png)

## Stop Demo and Delete

Just run the next script. This will drop topics, stop local CP and destroy local CP:

```bash
./02_stop_genAIKafkaConsumerDemo.sh
```
The terminal sessions did stopped (CTRL+c) manually.

END
