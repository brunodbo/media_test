#!/bin/bash
PROFILE_NAME="media_test"

BASEDIR=`php -r "echo dirname(realpath('$0'));"`
OLDDIR=`pwd`
cd $BASEDIR

mkdir old_contrib
mkdir old_contrib/modules
for contrib in modules/contrib modules/development libraries
do
    mv -f $contrib old_contrib/$contrib
done

# Exclude custom theme from deletion.
mkdir old_contrib/themes
find themes/contrib -mindepth 1 -maxdepth 1 -not -name $PROFILE_NAME -exec mv {} old_contrib/themes \;

drush make $1 --working-copy --yes --no-core --contrib-destination=. $PROFILE_NAME.make.yml
# If the drush make ran without errors, we can continue
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    # ./copy_and_patch_locally.sh
    # If we still have no errors, go ahead and delete the backups
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        rm -rf old_contrib
        echo "backups deleted"
    else
        echo "There was a problem with local patches. Backups have been left intact."
    fi
else
    # Things went wrong - back-up from old_contrib
    rsync -av old_contrib/ .
    rm -rf old_contrib
fi


# Go back where we came from.
cd $OLDDIR
