# -*- mode: sh; -*-

# Load NVM
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
    export NVM_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs
    . "$NVM_DIR/nvm.sh"
fi
