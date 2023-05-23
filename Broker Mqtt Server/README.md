# Broker Mqtt Server
This section shows how to install the server and config your mosquitto.conf file

# Install Server
Go to the official Eclipse Mosquitto website (https://mosquitto.org/download/) and select the installation for your current System.
After the installation is complete you can config your mosquitto.conf file.

# Configuration file
In the mosquitto installation path edit your 'mosquitto.conf' file to one of the configs below. Don't forget to chage the path in config files.

## mosquitto_sample
This config uses port 1883 wich means no TLS security protocol, it is a simple connection but not safe.

## mosquitto_basic
This config uses port 1883, wich means no TLS security protocol, but require user and password to connect, it is a simple connection but not safe.
Use 'mosquitto_passwd' to encrypt your MqttPass.txt file

## mosquitto_encrypted
This config uses port 8883, wich means TLS security protocol active, is the safest way to use mqtt connection. Will require RSA signed certificates to allow connection.
