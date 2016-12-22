# Cassandra on OpenShift CDK

This is a very simple Docker build for Cassandra, intended for push into the OpenShift CDK. I wanted to use Cassandra, and OpenShift required that containers do not run as root, hence this project. That's it!

### How to use

This assumes you have the CDK up and running - if not, see my **s2i-java** project for details.

#### Build and install the Cassandra image

_TODO there's almost certainly a simpler way of doing it than this..._

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
Then deploy the Cassandra image:
```
oc new-app cassandra-cdk
```
You can rsh to it using the oc command and the deployed pod name:
```
oc get pods
oc rsh <pod name>
