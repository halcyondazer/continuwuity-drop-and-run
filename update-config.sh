#!/bin/bash

if [[ -z "$1" ]]; then
   echo "run this with your domain as argument."
   echo "bash update-config.sh yourdomain.tld"
   exit
fi

CONF_DIR=../continuwuity-$1
BACKUPDIR=../continuwuity-$1.backup-$(date +%Y-%M-%d-%s)

docker compose down

LIVEKIT_KEY=$(cat $CONF_DIR/KEYDIR/LIVEKIT_KEY)
LIVEKIT_SECRET=$(cat $CONF_DIR/KEYDIR/LIVEKIT_SECRET)
REGISTRATION_KEY=$(cat $CONF_DIR/KEYDIR/REGISTRATION_KEY)

mv $CONF_DIR $BACKUPDIR

cp -r continuwuity-skeleton $CONF_DIR

find $CONF_DIR -type f -exec sed -i 's/xxxxxxxxxxxxxxx/'"$LIVEKIT_KEY"'/g' {} \;
find $CONF_DIR -type f -exec sed -i 's/zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz/'"$LIVEKIT_SECRET"'/g' {} \;
find $CONF_DIR -type f -exec sed -i 's/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy/'"$REGISTRATION_KEY"'/g' {} \;

cd $CONF_DIR
mkdir KEYDIR

echo $LIVEKIT_KEY > KEYDIR/LIVEKIT_KEY
echo $LIVEKIT_SECRET > KEYDIR/LIVEKIT_SECRET
echo $REGISTRATION_KEY > KEYDIR/REGISTRATION_KEY

echo "copying database from $BACKUPDIR"
cp -r $BACKUPDIR/database .

echo "your updated configuration is in the $CONF_DIR folder."
echo "do you want to start it now? enter 'yes'."
read confirmation
if [[ $confirmation = "yes" ]]; then
   echo "starting the server using docker compose..."
   docker compose pull
   docker compose up -d
fi
