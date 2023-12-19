# -*- sh-basic-offset: 2; -*-
# vim: ft=zsh ts=2 sts=2 sw=2 et

# Install VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
