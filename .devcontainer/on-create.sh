#!/bin/bash

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"

export REPO_BASE=$PWD

export PATH="$PATH:$REPO_BASE/.cli"
export GOPATH="$HOME/go"

mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.oh-my-zsh/completions"

{
    echo "defaultIPs: $PWD/ips"
    echo "reservedClusterPrefixes: corp-monitoring central-mo-kc central-tx-austin east-ga-atlanta east-nc-raleigh west-ca-sd west-wa-redmond west-wa-seattle"
} > "$HOME/.kic"

{
    #shellcheck disable=2016,2028
    echo 'hsort() { read -r; printf "%s\\n" "$REPLY"; sort }'
    echo ""

    # add cli to path
    echo "export PATH=\$PATH:$REPO_BASE/.cli"
    echo "export GOPATH=\$HOME/go"
    echo "export REPO_BASE=$PWD"
    echo "export AKDC_REPO=$GITHUB_REPOSITORY"
    echo "export AKDC_SSL=cseretail.com"
    echo "export AKDC_GITOPS=true"
    echo "export AKDC_DNS_RG=tld"
    echo ""

    echo "if [ \"\$PAT\" != \"\" ]"
    echo "then"
    echo "    export GITHUB_TOKEN=\$PAT"
    echo "    export AKDC_PAT=\$PAT"
    echo "fi"
    echo ""

    echo "compinit"
} >> "$HOME/.zshrc"

echo "create local registry"
docker network create k3d
k3d registry create registry.localhost --port 5500
docker network connect k3d k3d-registry.localhost

echo "kic cluster create"
kic cluster create

# install cobra
# go install -v github.com/spf13/cobra/cobra@latest

# # install go modules
# go install -v golang.org/x/lint/golint@latest
# go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
# go install -v github.com/ramya-rao-a/go-outline@latest
# go install -v github.com/cweill/gotests/gotests@latest
# go install -v github.com/fatih/gomodifytags@latest
# go install -v github.com/josharian/impl@latest
# go install -v github.com/haya14busa/goplay/cmd/goplay@latest
# go install -v github.com/go-delve/delve/cmd/dlv@latest
# go install -v honnef.co/go/tools/cmd/staticcheck@latest
# go install -v golang.org/x/tools/gopls@latest

# clone repos
cd ..
git clone https://github.com/retaildevcrews/bartr-fleet gitops
git clone https://github.com/retaildevcrews/dotnet-webapi-template template
cd "$REPO_BASE" || exit

echo "generating kic completion"
flt completion zsh > "$HOME/.oh-my-zsh/completions/_flt"
kic completion zsh > "$HOME/.oh-my-zsh/completions/_kic"

# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"
