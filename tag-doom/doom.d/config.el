;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font                 (font-spec :family "Sarasa Mono SC" :size 13.5)
      doom-variable-pitch-font  (font-spec :family "Iosevka Etoile")
      doom-serif-font           (font-spec :family "Iosevka Slab"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Built-in                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq frame-title-format "%b – Emacs")

;; Repository Mirror ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq package-archives
;;       '(("melpa-cn"  . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/melpa/")
;;         ;; ("org-cn"    . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/org/")
;;         ("gnu-cn"    . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/gnu/")
;;         ("nongnu-cn" . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/nongnu/")))

;; Font ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; It's good practice to set fonts for a wide variety of non-ASCII
;; characters in the current/default fontset
(add-hook! 'after-init-hook
  (dolist (charset '(cjk-misc kana bopomofo han))
    ;; (set-fontset-font (frame-parameter nil 'font) charset
    (set-fontset-font "fontset-auto1" charset
                      (font-spec :family "Sarasa Mono SC")))
  )

;; Editing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Reset var `fill-column' from 80
(setq-default fill-column 72)

(setq delete-by-moving-to-trash t)

(setq safe-local-variable-values
      '((org-confirm-babel-evaluate)
        (org-enforce-todo-dependencies)
        (org-enforce-todo-dependencies . t)
        (org-log-into-drawer . t)
        (org-modern-timestamp . 'nil)
        (org-odt-content-template-file . "~/Templates/note-content-template.xml")
        (org-odt-content-template-file . "~/Templates/pad-content-template.xml")
        (org-odt-display-outline-level . 0)
        (pangu-spacing-real-insert-separtor)
        (pangu-spacing-real-insert-separtor . t)
        (pangu-spacing-separator . "")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :input                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :completion                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :ui                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; doom-dashboard
(setq fancy-splash-image (concat doom-private-dir
                                 "banners/blackhole.png"
                                 ;; "banners/emacs-e-logo.png"
                                 ))

;; window-select ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; (map! :after winum
;;       "M-1" #'winum-select-window-1
;;       "M-2" #'winum-select-window-2
;;       "M-3" #'winum-select-window-3
;;       "M-4" #'winum-select-window-4
;;       "M-5" #'winum-select-window-5
;;       "M-6" #'winum-select-window-6
;;       "M-7" #'winum-select-window-7
;;       "M-8" #'winum-select-window-8
;;       "M-9" #'winum-select-window-9
;;       "M-0" #'winum-select-window-0-or-10)

;; zen ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (featurep! :ui zen)
  (setq +zen-text-scale 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :editor                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :emacs                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dired ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! dirvish-subtree
  (set-face-attribute 'dirvish-subtree-state nil :family "Sarasa Term SC")
  ;; (setq! dirvish-subtree-state-style 'plus)
  (setq dirvish-subtree--state-icons (cons (propertize "▼" 'face 'dirvish-subtree-state)
                                           (propertize "▶" 'face 'dirvish-subtree-state)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :term                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :checkers                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :tools                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lookup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (featurep! :tools lookup)
  (appendq! +lookup-provider-url-alist
            '(("Dict.cn" "https://dict.cn/search?q=%s"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :os                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :lang                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; cc ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This will both set your clangd flags and choose =clangd= as the default LSP
;; server everywhere clangd can be used.
(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=2"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

;; org ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! org
  (setq org-agenda-files "~/org-agenda-files"
        org-enforce-todo-dependencies t
        org-odt-create-custom-styles-for-srcblocks nil
        ;; org-hide-leading-stars nil
        org-startup-indented nil)
  (add-hook 'org-mode-hook 'org-num-mode))

(after! org-duration
  (setq org-duration-units `(("min" . 1)
                             ("h" . 60)
                             ("d" . ,(* 60 8))
                             ("w" . ,(* 60 8 5))
                             ("m" . ,(* 60 8 5 4))
                             ("y" . ,(* 60 8 5 4 11))))
  (org-duration-set-regexps))

(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars "◉○🞛◇✿❀⚛✸"
        ;; org-modern-timestamp '(" %F %a" . " %R ")
        )
  ;; (dolist (face '(org-modern-date-active
  ;;                 org-modern-date-inactive
  ;;                 org-modern-time-active
  ;;                 org-modern-time-inactive))
  ;;   (set-face-attribute face nil :height 1.25))
  )

;; DEPRECATED: Package `org-superstar' is superseded by `org-modern'
(after! org-superstar
  ;; good candidates: ▶▷✶⬢⬡☀☼
  (setq org-superstar-headline-bullets-list '(?◉ ?○ ?🞛 ?◇ ?✿ ?❀ ?⚛ ?✸)
        org-superstar-leading-bullet " ․")
  (set-face-attribute 'org-list-dt nil :family "Sarasa Term SC")
  ;; (set-face-attribute 'org-superstar-item nil :family "Sarasa Term SC")
  (set-face-attribute 'org-superstar-leading nil :family "Sarasa Term SC"))

;; plantuml ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (featurep! :lang plantuml)
  (setq plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar"))

;; python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-hook! 'python-mode-hook +format-with '(ruff-isort ruff))

;; sh ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; disable formatting-on-save behavior in ZSH script buffers
;; because an adequate formatter is missing
(add-hook! 'sh-mode-hook
  (cond ((equal sh-shell 'zsh) (setq +format-inhibit t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :email                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :app                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! emms
  (setq emms-player-mpd-music-directory "~/Music/"
        ;; emms-player-mpd-sync-playlist nil
        emms-volume-change-function 'emms-volume-mpd-change)
  (add-to-list 'emms-info-functions 'emms-info-mpd)
  (add-to-list 'emms-player-list 'emms-player-mpd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Doom :config                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
