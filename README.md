Routing mongodb connections over OpenShift Routes
================================

While OpenShift is perfectly adept at handling inbound HTTP and
related traffic, things get a little more complicated when you are
dealing with arbitrary protocols over non-80/443 ports.  Several
mechanism are available to accommodate this kind of traffic, including
nodePort, externalIP and even custom routers.  However, each of these
approaches come with additional maintenance overhead and complexity.

A common class of application requiring non-standard cluster ingress
are databases.  For instance, accessing a mongodb cluster hosted on
OpenShift from outside the cluster might involve using an externalIP
service to map mongodb's 27107 port to a new IP exposed on a worker
node in your cluster.  But what happens when you are talking about
tens, hundreds or thousands of database instances?  IPs can be scarce
resources, and the management overhead of tracking IP usage can become
problematic.

The good news is that many databases have the ability to wrap their
custom protocols in TLS, making them look like any other https
connection, and routable by the standard OpenShift router.  Instead of
connecting your database to MY_IP:27107, you point it at a normal
OpenShift route on port 443, which passes the connection on through to
the database.  This has the added benefit of encrypting your database
connections over the wire.  Mongodb is one such database.  The scripts
and yaml files in this project show the steps required to establsh
monogdb connections over normal OpenShift routes.

Good luck!

AG
