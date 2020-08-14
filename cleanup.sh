#!/bin/sh

PROJECT=mongodb-test

oc delete project $PROJECT > /dev/null
until ! oc project $PROJECT > /dev/null 2>&1 ; do
    sleep 1;
done;

echo Done
	  
