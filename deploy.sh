#!/bin/sh
# Inspired by the work of https://github.com/eldarlabs/ghpages-deploy-script

# Store the most recent commit hash
commit=$(git rev-parse --short HEAD)

# abort the script if there is a non-zero error
set -e

# Log some stuff
echo "Starting deploy of $commit"
pwd
git status

# Setup git config
git config --global user.email "$GH_EMAIL" > /dev/null 2>&1
git config --global user.name "$GH_NAME" > /dev/null 2>&1

# Our test already built it, now we switch to master,
# replace with newest build, and clean it up
git checkout master
find . -not -path './public*' \
       -not -path './.git*' \
       -not -path './README*' \
       -not -path './LICENSE*' \
       -delete
mv public/* .
rm -rf deploy.sh \

# Commit it
git add -A
git commit -m "Deploy $commit"
git push origin master

# Clear cache on cloudflare
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE/purge_cache" \
     -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
     -H "X-Auth-Key: $CLOUDFLARE_KEY" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'

echo "Finished Deployment!"