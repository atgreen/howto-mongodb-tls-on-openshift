#!/bin/sh

set -e

PROJECT=mongodb-test

oc new-project $PROJECT

openssl req -x509 -addext "subjectAltName = DNS:localhost" -nodes -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -sha256 <<EOF
CA
Ontario
Toronto
Labdroid
Lab
labdroid.net
green@moxielogic.com
EOF

# Mongodb needs the key and cert concatenated together.
cat key.pem cert.pem > mongodb.pem

# Create a secret we will mount into the database containers.
oc create secret generic mongodb-cert-secret --from-file=mongodb-cert-secret.pem=./mongodb.pem 

# Start up the database and create the service and route
oc create -f pod.yaml
oc create -f service.yaml
oc create -f route.yaml

# Note that we're not validating the cert.  We're only using it to get intor the cluster,
# not to validate the server.
echo Now try...
echo podman run --rm -t -i registry.access.redhat.com/rhscl/mongodb-36-rhel7:latest mongo --ssl mongodb-mongodb-test.apps.ocp.labdroid.net:443 --sslAllowInvalidCertificates

