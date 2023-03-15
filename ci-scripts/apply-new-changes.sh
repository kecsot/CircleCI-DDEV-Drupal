#!/bin/sh
set -e

ssh -T -o "StrictHostKeyChecking no" $ENV_SSH_USER@$ENV_SSH_HOST bash -c "
  cd $FOLDER_PROJECT
  git pull
  vendor/bin/drush cr
  composer install --prefer-dist
  vendor/bin/drush updb -y
  vendor/bin/drush cim -y
  vendor/bin/drush cr
"
# TODO: Disable removed modules before composer install.
