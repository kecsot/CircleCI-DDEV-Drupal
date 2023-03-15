#!/bin/sh
set -e

ssh -T -o "StrictHostKeyChecking no" $ENV_SSH_USER@$ENV_SSH_HOST bash -c "
    cd $FOLDER_PROJECT
    vendor/bin/drush cex -y
    git pull
    git add .
    git diff main config/* > $FOLDER_BACKUP/$CIRCLE_SHA1/diff.patch
    git checkout --force
"

scp $ENV_SSH_USER@$ENV_SSH_HOST:$FOLDER_BACKUP/$CIRCLE_SHA1/diff.patch /tmp/diff.patch

if [ -s /tmp/diff.patch ]
then
    git apply /tmp/diff.patch
    git checkout -b remote-changes-from-$CIRCLE_SHA1
    git add .
    git commit -m "CircleCI Lookup Remote changes"
    git push origin remote-changes-from-$CIRCLE_SHA1

    echo "Deploy exited. Remote changes found"
    exit 1
fi
