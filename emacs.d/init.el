;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;; Commentary:
;;
;;; Code:

;;===========================
;; Bootstrap
;;===========================
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents) (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;===========================
;; Global settings
;;===========================
(setq-default
  inhibit-startup-message t
  column-number-mode t
  indent-tabs-mode nil
  show-trailing-whitespace t
  truncate-lines nil
  linum-format "%4d  ")

(menu-bar-mode -1)
(show-paren-mode)
(global-linum-mode)
(load-theme 'wombat)
(set-face-foreground 'minibuffer-prompt "yellow")
(windmove-default-keybindings)

(global-set-key (kbd "<f5>") 'eval-buffer)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;===========================
;; Packages
;;===========================
(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))

(use-package ivy
  :ensure t
  :init
  (ivy-mode 1)

  :config
  (setq ivy-use-virtual-buffers t))


; http://stackoverflow.com/a/22922161/241660
(setq evil-want-C-i-jump nil)

; https://bytebucket.org/lyro/evil/raw/default/doc/evil.pdf
(use-package evil
  :ensure t
  :config

  (use-package evil-leader
    :ensure t
    :init
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")
    (evil-leader/set-key ":" 'eval-expression
                         "g" 'magit-status
                         "w" 'save-buffer
                         "," 'smex))

  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :ensure t)

  ;; has to this after evil-leader due to https://github.com/cofi/evil-leader/issues/10
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "<down>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<up>")   'evil-previous-visual-line))

(use-package magit
  :ensure t)

(use-package flycheck
  :ensure
  :init (global-flycheck-mode))

(use-package company
  :ensure t
  :config (global-company-mode)
          (with-eval-after-load 'company
          (define-key company-active-map (kbd "M-n") nil)
          (define-key company-active-map (kbd "M-p") nil)
          (define-key company-active-map (kbd "j") #'company-select-next)
          (define-key company-active-map (kbd "k") #'company-select-previous)))

(use-package go-mode
  :ensure t
  :init
  (add-hook 'before-save-hook 'gofmt-before-save)

  :config
  (setq gofmt-command "goimports")
  (use-package company-go
    :ensure t
    :config
    (add-hook 'go-mode-hook (lambda ()
                              (set (make-local-variable 'company-backends) '(company-go))
                              (company-mode))))

  (use-package go-eldoc
    :ensure t
    :config (add-hook 'go-mode-hook 'go-eldoc-setup))

  (use-package go-rename
    :ensure t)

  (use-package go-guru
    :ensure t)

  (evil-leader/set-key-for-mode 'go-mode "d" 'godoc-at-point)
  (evil-leader/set-key-for-mode 'go-mode "c" 'go-guru-referrers)
  (evil-leader/set-key-for-mode 'go-mode "rn" 'go-rename))

;(use-package intero
;  :ensure t
;  :config (add-hook 'haskell-mode-hook 'intero-mode))

(use-package projectile
  :ensure t)

(provide 'init)

;;; init.el ends here
