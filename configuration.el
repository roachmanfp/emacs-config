(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("nongnu"."https://elpa.nongnu.org/nongnu/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (require 'use-package)
  (setq use-package-always-ensure t))

(setq inhibit-startup-message t
      view-read-only t)

(setq enable-recursive-minibuffers t)

(desktop-save-mode 1)
(save-place-mode 1)

(when (version<= "27.1" emacs-version)
  (global-so-long-mode +1))

(electric-pair-mode t)

(defalias 'yes-or-no #'y-or-n-p)

(setq isearch-allow-scroll t) ; Scroll while searching
(setq search-default-mode 'char-fold-to-regexp)  ; cafe = café

(use-package vertico
  :init (vertico-mode +1))
  
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init (savehist-mode +1))

;; Provides command annotations in addition to vertico
(use-package marginalia
  :init (marginalia-mode +1))

(use-package corfu
  ;; Optional customizations
  ;; :custom
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

;; Enable indentation+completion using the TAB key.
;; `completion-at-point' is often bound to M-TAB.
(setq tab-always-indent 'complete)

(use-package magit
:bind (("C-x g" . magit)
       ("C-x C-g" . magit-status)))

;; don't use a separate Frame for the control panel
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; horizontal split is more readable
(setq ediff-split-window-function 'split-window-horizontally)

;; restore window config upon quitting ediff
(defvar ue-ediff-window-config nil "Window config before ediffing.")
(add-hook 'ediff-before-setup-hook
	  (lambda ()
	    (setq ue-ediff-window-config (current-window-configuration))))

(dolist (hook '(ediff-suspend-hook ediff-quit-hook))
  (add-hook hook
	    (lambda ()
	      (set-window-configuration ue-ediff-window-config))))

;; offer to clean up files from ediff sessions
(add-hook 'ediff-cleanup-hook (lambda () (ediff-janitor t nil)))

(use-package diff-hl
  :config (diff-hl-flydiff-mode t)
  :hook ((prog-mode . turn-on-diff-hl-mode)
	 (vc-dir-mode . turn-on-diff-hl-mode)))

(setq visible-bell t
	 use-file-dialog nil
	 use-dialog-box nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode 1) ;

(setq scroll-conservatively 100000 ; Disables jumpy scrolling
      scroll-margin 7
      mouse-wheel-scroll-amount `(1 ((sshift) . 1)) ; One line per time mouse scrolling
      mouse-wheel-progressive-speed nil )

(use-package ace-window
  :bind ("C-x o" . ace-window))

(use-package ample-theme
  :init (load-theme `ample-flat t))

(use-package mood-line
 :config (mood-line-mode)
 :custom (setq mood-line-glyph-alist mood-line-glyphs-unicode
	       mood-line-format mood-line-format-default-extended))

(use-package treemacs
  :hook (after-init . treemacs)
  :bind (:map global-map
	      ("M-0"       . treemacs-select-window)
	      ("C-x t 1"   . treemacs-delete-other-windows)
	      ("C-x t t"   . treemacs)
	      ("C-x t d"   . treemacs-select-directory)
	      ("C-x t B"   . treemacs-bookmark)
	      ("C-x t C-t" . treemacs-find-file)
	      ("C-x t M-t" . treemacs-find-tag))
  :config (setq treemacs-follow-after-init t
		treemacs-is-never-other-window t
		treemacs-width 20)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'simple)
  (treemacs-fringe-indicator-mode t)
  (when treemacs-python-executable
    (treemacs-git-commit-diff-mode t)))

; Adds treemacs icons to dired buffers
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

; Git integration
(use-package treemacs-magit
  :after (treemacs magit))

(setq-default major-mode
              (lambda () ; guess major mode from file name
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(use-package eglot)

(use-package markdown-mode
 :mode ("README\\.md\\'" . gfm-mode)
 :init (setq markdown-command "pandoc"))

(use-package pdf-tools
  :config (pdf-tools-install)
  :hook (pdf-view-mode . auto-revert-mode))

(use-package yaml-mode
:mode ("\\.yml\\'" . yaml-mode)
:mode ("\\.yaml\\'" . yaml-mode))
