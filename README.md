# terraform-codepipeline-template

This repo provides an example of how to setup a basic CICD pipeline using AWS CodeCommit
,AWS CodePipeline, and AWS CodeDeploy.

We will also setup Slack notifications, in order to pass build status updates. 

This project creates two CICD pipeline of the same repo and build the master & dev branches.

The master branch always succeeds and the dev branch always fails

## TODO

* configure the cloudwatch event rule to filter by pipeline
* build notification message for successful completed build
* build notification message for failed build