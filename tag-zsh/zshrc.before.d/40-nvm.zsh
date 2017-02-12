# vim: ft=zsh ts=2 sts=2 sw=2 et

# Load NVM
# NOTE: NVM will be loaded by Prezto module `node', here only define required envs.
if (( $+commands[brew] )) && [[ -d "$(brew --prefix nvm 2>/dev/null)" ]]; then
  export NVM_DIR=$HOME/.nvm
  export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node
  export NVM_IOJS_ORG_MIRROR=http://npm.taobao.org/mirrors/iojs
fi
