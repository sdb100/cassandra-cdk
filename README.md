# Cassandra on OpenShift CDK

This is a very simple Docker build for Cassandra on rhel7, for push into the OpenShift CDK. I wanted to use rhel, and OpenShift required that containers do not run as root, hence this project. That's it!

### How to use

This assumes you have the CDK up and running - if not, see my **s2i-java** project for details.

#### Build and install the Cassandra image
Clone this repo locally, somewhere under your home dir. The CDK VM mounts your home dir by default, so once you have used _vagrant ssh_, you should be able to navigate to the cloned repo from within the image. The following assumes you have done so, and run _oc login_. 

First build the cassandra-cdk image. 
```
docker build -t cassandra-cdk . 
```
Then create the image stream for the builder image:
```
oc create -f ./cassandra-cdk-imagestream.json 
```
You'll need some details from this, so run:
```
oc describe is
```
This will give you the ip:port details of OpenShift's internal Docker repo in the Docker pull spec. 

You'll also need a logon token for the Docker repo, so get it using:
```
oc whoami -t 
```
You can then tag the builder image you created just now, logon to the OpenShift Docker repo, and push the image:
```
docker tag cassandra-cdk  <docker pull spec>
docker login -u admin -e <your email address> -p <logon token> <docker ip:port>
docker push <docker pull spec>
```
#### Build and run something
Use the web console and "add something" to your project. 