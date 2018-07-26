#!/bin/bash

echo "Update certs and install curl"
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -

export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "Install bazel"
sudo apt-get update
sudo apt-get install google-cloud-sdk bazel -y

echo "Authenticate to google cloud"
echo $GCLOUD_SERVICE_KEY | base64 --decode --ignore-garbage > ${GOOGLE_APPLICATION_CREDENTIALS}
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud config set project $GCLOUD_PROJECT
docker login -u oauth2accesstoken -p "$(gcloud auth application-default print-access-token)" https://gcr.io
docker login -u oauth2accesstoken -p "$(gcloud auth application-default print-access-token)" https://asia.gcr.io
docker login -u oauth2accesstoken -p "$(gcloud auth application-default print-access-token)" https://us.gcr.io

echo "Authenticate to Vorstella container repo"
docker login -u $VORSTELLA_CONTAINER_USER -p $VORSTELLA_CONTAINER_PASSWORD containers.prod.noc.vorstella.com

echo "Populate build enviroment vars"
echo "export BUILD_ID=$CIRCLE_BUILD_NUM" >> $BASH_ENV
echo "export BRANCH_NAME=$CIRCLE_BRANCH" >> $BASH_ENV
echo "export PR_NAME=$CIRCLE_PR_NUMBER"  >> $BASH_ENV

echo "Remove gitconfig so we don't use SSH"
rm -f ~/.gitconfig

