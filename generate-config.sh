#!/bin/bash

if [[ -z "$1" ]]; then
   echo "run this with your domain as argument."
   echo "bash generate-config.sh yourdomain.tld"
   exit
fi

CONF_DIR=../continuwuity-$1
BACKUPDIR="$CONF_DIR.backup-$(date +%Y-%M-%d-%s)

cp -r continuwuity-skeleton $CONF_DIR

KEYS=$(sudo docker run --rm livekit/livekit-server:latest generate-keys | cut -d ' ' -f 4)
LIVEKIT_KEY=$(echo $KEYS | cut -d ' ' -f 1)
LIVEKIT_SECRET=$(echo $KEYS | cut -d ' ' -f 2)
REGISTRATION_KEY=$(openssl rand -hex 32)
find $CONF_DIR -type f -exec sed -i 's/xxxxxxxxxxxxxxx/'"$LIVEKIT_KEY"'/g' {} \;
find $CONF_DIR -type f -exec sed -i 's/zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz/'"$LIVEKIT_SECRET"'/g' {} \;
find $CONF_DIR -type f -exec sed -i 's/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy/'"$REGISTRATION_KEY"'/g' {} \;

cd $CONF_DIR
mkdir KEYDIR
echo $LIVEKIT_KEY > KEYDIR/LIVEKIT_KEY
echo $LIVEKIT_SECRET > KEYDIR/LIVEKIT_SECRET
echo $REGISTRATION_KEY > KEYDIR/REGISTRATION_KEY

echo "your generated configuration is in the $CONF_DIR folder."
echo "do you want to start it now? enter 'yes'."
read confirmation
if [[ $confirmation = "yes" ]]; then
   echo "starting the server using docker compose..."
   docker compose up -d
   docker compose logs | grep 'using the registration token'
   echo "The registration token you set in your configuration will not function until you create an account using the token above."
   echo "The registration token after that is: "
   grep 'registration_token = "' continuwuity.toml
fi
