#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "specify path to clone git repo for emacs"
    echo "\$ ${0} \$PATH_TO_CLONE"
    exit 1
fi

declare -r CLONE_PATH="${1}"

if [ -e "${CLONE_PATH}" ]; then
    echo "${CLONE_PATH} already exists"
    exit 1
fi

mkdir -p "${CLONE_PATH}" && cd "${CLONE_PATH}"

git init
# override ssh command for private key
git config core.sshCommand "ssh -i ~/.ssh/id_ed25519_freeaion"

# add remote repo
git remote add origin git@github.com:freeaion/emacs_setting.git

# pull!
git pull origin master
