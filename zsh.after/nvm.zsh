# Load NVM
# NOTE: NVM has already been loaded by Prezto module `node', here only define required envs
if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
  export NVM_DIR=$HOME/.nvm
  export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
  export NVM_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs
  # source $(brew --prefix nvm)/nvm.sh
fi
