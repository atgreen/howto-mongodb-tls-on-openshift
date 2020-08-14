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

cat key.pem cert.pem > mongodb.pem

oc create secret generic mongodb-cert-secret --from-file=mongodb-cert-secret.pem=./mongodb.pem 

oc create -f pod.yaml
oc create -f service.yaml
oc create -f route.yaml

echo Now try...
echo podman run --rm -t -i registry.access.redhat.com/rhscl/mongodb-36-rhel7:latest mongo --ssl mongodb-mongodb-test.apps.ocp.labdroid.net:443 --sslAllowInvalidCertificates

