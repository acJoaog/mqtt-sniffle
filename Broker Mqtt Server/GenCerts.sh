#!/bin/bash

# Define as variáveis de configuração
VALIDADE_DIAS=365
CA_KEY="ca.key.pem"
CA_CERT="ca-cert.pem"
SERVER_KEY="server.key"
SERVER_CERT="server-cert.pem"
CLIENT_KEY="client.key"
CLIENT_CERT="client-cert.pem"

IP="hostname" #name of your website
SUBJECT_CA="/C=BR/ST=MinasGerais/L=SantaRitaDoSapucai/O=Example/OU=CA/CN=$IP"
SUBJECT_SERVER="/C=BR/ST=MinasGerais/L=SantaRitaDoSapucai/O=Example/OU=server/CN=$IP"
SUBJECT_CLIENT="/C=BR/ST=MinasGerais/L=SantaRitaDoSapucai/O=Example/OU=client/CN=$IP"

read -p "Please enter the IP of the serverBroker :" yourip
echo  "Ip of the serverBroker->$yourip"

SB_NAME="subjectAltName = IP:$yourip" #"subjectAltName=DNS:example.com,IP:$IP"
echo ${SB_NAME}

MAX_DAYS=3650

# Gera uma chave privada para a CA (Certification Authority)
openssl genpkey -algorithm RSA -out "$CA_KEY"

# Gera um certificado autoassinado para a CA com validade de 365 dias
echo -e "$SUBJECT_CA\n$space" 
openssl req -x509 -nodes -sha256 -newkey rsa:2048 -subj "$SUBJECT_CA" -addext  "${SB_NAME}" -days ${MAX_DAYS} -keyout ca.key -out ca-cert.pem 

# Gera uma chave privada para o servidor
openssl genpkey -algorithm RSA -out "$SERVER_KEY"

# Gera uma solicitação de certificado (CSR - Certificate Signing Request) para o servidor
echo -e "$SUBJECT_SERVER\n$space"
openssl req -nodes -sha256 -new -subj "$SUBJECT_SERVER" -keyout server.key -out server.csr -addext "${SB_NAME}"

# Assina o CSR do servidor com a chave da CA para obter o certificado do servidor
openssl x509 -req -in "server.csr" -days $VALIDADE_DIAS -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial -out "$SERVER_CERT"

# Gera uma chave privada para o cliente
openssl genpkey -algorithm RSA -out "$CLIENT_KEY"

# Gera uma solicitação de certificado (CSR - Certificate Signing Request) para o cliente
echo -e "$SUBJECT_CLIENT\n$space"
openssl req -new -nodes -sha256 -subj "$SUBJECT_CLIENT" -out client.csr -keyout client.key

# Assina o CSR do cliente com a chave da CA para obter o certificado do cliente
openssl x509 -req -sha256 -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days ${MAX_DAYS}

# Limpa os arquivos temporários
rm -f "server.csr.pem" "client.csr.pem"

# Define permissões apropriadas para as chaves privadas (opcional)
chmod 400 "$CA_KEY" "$SERVER_KEY" "$CLIENT_KEY"

echo "Certificados e chaves gerados com sucesso:"
echo "CA Cert: $CA_CERT"
echo "Server Cert: $SERVER_CERT"
echo "Client Cert: $CLIENT_CERT"
echo "Server Key: $SERVER_KEY"
echo "Client Key: $CLIENT_KEY"
