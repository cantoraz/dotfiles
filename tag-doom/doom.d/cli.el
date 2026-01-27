;;; cli.el -*- lexical-binding: t; -*-

;; (setq doom-env-deny
;;       '(;; Unix/shell state that shouldn't be persisted
;;         "^HOME$" "^\\(OLD\\)?PWD$" "^SHLVL$" "^PS1$" "^R?PROMPT$" "^TERM\\(CAP\\)?$"
;;         "^USER$" "^GIT_CONFIG" "^INSIDE_EMACS$"
;;         ;; X server, Wayland, or services' env  that shouldn't be persisted
;;         "^\\(WAYLAND_\\)?DISPLAY$" "^DBUS_SESSION_BUS_ADDRESS$" "^XAUTHORITY$"
;;         ;; Windows+WSL envvars that shouldn't be persisted
;;         "^WSL_INTEROP$"
;;         ;; XDG variables that are best not persisted.
;;         "^XDG_CURRENT_DESKTOP$" "^XDG_RUNTIME_DIR$"
;;         "^XDG_\\(VTNR$\\|SEAT$\\|BACKEND$\\|SESSION_\\)"
;;         ;; Socket envvars, like I3SOCK, GREETD_SOCK, SEATD_SOCK, SWAYSOCK, etc.
;;         "SOCK$"
;;         ;; ssh and gpg variables that could quickly become stale if persisted.
;;         "^SSH_\\(AUTH_SOCK\\|AGENT_PID\\)$" "^\\(SSH\\|GPG\\)_TTY$"
;;         "^GPG_AGENT_INFO$"
;;         ;; Internal Doom envvars
;;         "^DEBUG$" "^INSECURE$" "^\\(EMACS\\|DOOM\\(LOCAL\\)?\\)DIR$"
;;         "^DOOM\\(PATH\\|PROFILE\\)$" "^__"

;;         ;; Custom
;;         "^DEBUGINFOD_URLS$"
;;         "^DESKTOP_SESSION$"
;;         "^DESKTOP_STARTUP_ID$"
;;         "^GDMSESSION$"
;;         "^GLFW_"
;;         "^GREP_"
;;         "^GTK_"
;;         "^IDEA_"
;;         "^KITTY_"
;;         "^LESS_"
;;         "^MOTD_SHOWN$"
;;         "^P9K_" "^_P9K_"
;;         "^PAM_KWALLET5_LOGIN$"
;;         "^QT_"
;;         "^SAL_"
;;         "^WINDOWID$"
;;         "^XDG_DATA_DIRS$" "^XDG_\\(GREETER\\|SEAT\\)_"
;;         "^XMODIFIERS$"
;;         ))
(setq doom-env-deny '(".*"))
(setq doom-env-allow
      '("^_$"
        "^GOPATH$"
        "^PATH$"
        ))
