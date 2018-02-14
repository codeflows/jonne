#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "Please provide version (e.g. 0.1.0) as parameter";
  exit 1
fi

VERSION=$1
TAGGED_IMAGE=codeflows/jonne:$VERSION

docker build -t $TAGGED_IMAGE .
docker push $TAGGED_IMAGE
git tag $VERSION

echo "Done building. Next do \"git push --tags\""
