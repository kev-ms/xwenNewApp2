#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "post-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-create start" >> "$HOME/status"

# secrets are not available during on-create

if [ "$PAT" != "" ]
then
    mkdir -p "$HOME/.ssh"
    echo -n "$PAT" > "$HOME/.ssh/akdc.pat"
    chmod 600 "$HOME/.ssh/akdc.pat"
fi

# save ssl certs
# echo "$AKDC_SSL_KEY" | base64 -d > "$HOME/.ssh/certs.key"
# echo "$AKDC_SSL_CERT" | base64 -d > "$HOME/.ssh/certs.pem"

# add shared ssh key
# echo "$ID_RSA" | base64 -d > "$HOME/.ssh/id_rsa"
# echo "$ID_RSA_PUB" | base64 -d > "$HOME/.ssh/id_rsa.pub"

# # save keys
# echo -n "$AKDC_MI" > "$HOME/.ssh/mi.key"
# echo -n "$AKDC_LOKI_URL" > "$HOME/.ssh/fluent-bit.key"
# echo -n "$AKDC_PROMETHEUS_KEY" > "$HOME/.ssh/prometheus.key"
# echo -n "$AKDC_EVENT_HUB" > "$HOME/.ssh/event-hub.key"

# # set file mode
# chmod 600 "$HOME"/.ssh/id*
# chmod 600 "$HOME"/.ssh/certs.*
# chmod 600 "$HOME"/.ssh/*.key

# update oh-my-zsh
git -C "$HOME/.oh-my-zsh" pull

# update repos
git -C ../template pull
git -C ../gitops pull
git -C ../gitops checkout bartr-demo-fleet

export PATH=$PATH:$PWD/.cli
export REPO_BASE=$PWD
export AKDC_REPO=retaildevcrews/bartr-app
export AKDC_BRANCH=bartr-demo-fleet

kic new dotnet webapi MyApp

echo "post-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-create complete" >> "$HOME/status"
