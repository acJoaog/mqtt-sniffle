# mqtt-sniffle
A repository intended for mqtt connections and how to implement a functional android app using local broker and database.

# Getting Started to Mqtt
MQTT (Message Queuing Telemetry Transport) is a lightweight messaging protocol designed for Internet of Things (IoT) applications where low bandwidth and limited resources are an issue. It is used to send and receive messages between devices (usually sensors and actuators) over a network.

An MQTT server, also known as an MQTT broker, is a server application that acts as an intermediary between MQTT clients. It receives messages published by MQTT clients and delivers them to MQTT clients subscribed to related topics. The server also maintains a list of connected clients and manages the delivery of messages to the appropriate recipients.

MQTT servers use a publish-subscribe architecture, where clients can subscribe to specific topics and the server forwards all messages published on those topics to all subscribed clients. This approach enables efficient communication among many devices with minimal network overhead and enables asynchronous message passing between devices. MQTT is commonly used in applications such as home automation, industrial control, and smart cities.

