#!/bin/bash

# SITE_ALIAS=$1
SITE_ALIAS=@media_test

# Backup db.
drush $SITE_ALIAS sql-dump --result-file --gzip

# Install site.
drush $SITE_ALIAS si media_test --account-pass=admin -y

# Revert features
drush $SITE_ALIAS fra -y

# Logs in admin user
drush $SITE_ALIAS uli --uid=1 -y
