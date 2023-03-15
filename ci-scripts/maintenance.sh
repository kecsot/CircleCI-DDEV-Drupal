#!/bin/sh
set -e

ssh -T -o "StrictHostKeyChecking no" $ENV_SSH_USER@$ENV_SSH_HOST bash -c "
  $FOLDER_PROJECT/vendor/bin/drush sset system.maintenance_mode $1
"
