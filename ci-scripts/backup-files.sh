#!/bin/sh
set -e

ssh -T -o "StrictHostKeyChecking no" $ENV_SSH_USER@$ENV_SSH_HOST bash -c "
  mkdir -p $FOLDER_BACKUP/$CIRCLE_SHA1
  $FOLDER_PROJECT/vendor/bin/drush cr
  $FOLDER_PROJECT/vendor/bin/drush sql-dump --result-file=$FOLDER_BACKUP/$CIRCLE_SHA1/dump.sql
  tar -zcvf $FOLDER_BACKUP/$CIRCLE_SHA1/public-files.tar.gz $FOLDER_PROJECT/web/sites/default/files/
  tar -zcvf $FOLDER_BACKUP/$CIRCLE_SHA1/private-files.tar.gz $FOLDER_PROJECT/private/
  cd $FOLDER_PROJECT
  git show --summary >> $FOLDER_BACKUP/$CIRCLE_SHA1/git-summary.log
"
