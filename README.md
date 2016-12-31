# Cassandra on OpenShift CDK

This is a very simple Docker build for Cassandra, intended for push into the OpenShift CDK. I wanted to use Cassandra, and OpenShift required that containers do not run as root, hence this project. That's it!

### How to use

This assumes you have the CDK up and running - if not, see my **s2i-java** project for details.

#### Build and install the Cassandra image

In the CDK, log in to your account using _oc login_, and create a new project (if you haven't already got one) using _oc new-project_ or the UI.

Then add this repo as an app:
```
oc new-app https://github.com/sdb100/cassandra-cdk.git 
```

You can rsh to it using the oc command and the deployed pod name:
```
oc get pods
oc rsh <pod name>
```