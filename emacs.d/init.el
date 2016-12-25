;; --------------------------------
;;  ALWAYS Read the Document First
;; --------------------------------
;;
;;     "C-h f" = read function doc
;;     "C-h v" = read variable doc
;;     "C-h k" = describe key
;;
;; ------------
;;  References
;; ------------
;;
;;     "when to use 0/1/t/nil" -> http://emacs.stackexchange.com/a/2449
;;
;; ---------
;;  Actions
;; ---------
;;
;;     "M-x save-buffers-kill-emacs" -> entirely close a server started with "--daemon"   ;; TODO: bind a key with "y/n" confirmation
;;
;; ------
;;  TODO
;; ------
;;     * key bind for `magit-status`
;;
;;
;; --------
;;  ISSUES
;; --------
;;
;;     Delay between ESC & modeswitch : http://bitbucket.org/lyro/evil/issues/69/delay-between-esc-or-c-and-modeswitch
;;                                      Solved by adding "set -s escape-time 0" in ~/.tmux.conf


(require 'package)

(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;;===========================
;; Global settings
;;===========================

(global-set-key (kbd "<f5>") 'eval-buffer)

(setq-default
  column-number-mode -1
  indent-tabs-mode nil
  make-backup-files nil
  mouse-yank-at-point t
  show-trailing-whitespace t
  truncate-lines nil
  x-select-enable-clipboard t
  interprogram-paste-function 'x-selection-value
  interprogram-cut-function 'paste-to-osx  ;; TODO: switch-case for ubuntu & mac 
  inhibit-startup-message t
  global-linum-mode t
  linum-format "%4d ")


;;===========================
;; Packages
;;===========================

;--------------------
; ido-mode
;--------------------
(use-package ido
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (setq ido-enable-flex-matching 1)
  (setq ido-use-filename-at-point 1)
  (setq ido-auto-merge-work-directories-length 0)
  (setq ido-use-virtual-buffers 1))

;--------------------
; evil
;--------------------

; https://bytebucket.org/lyro/evil/raw/default/doc/evil.pdf
(use-package evil
  :ensure t
  :config
  (define-key evil-normal-state-map (kbd "<down>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<up>")   'evil-previous-visual-line)

  ;; http://stackoverflow.com/questions/27480231/emacs-evil-mode-and-ensime
  (evil-define-key 'normal ensime-mode-map (kbd "C-]") #'ensime-edit-definition)
  (evil-define-key 'normal ensime-mode-map (kbd "<f5>") #'ensime-sbt-do-run)
  (evil-define-key 'normal ensime-mode-map (kbd "<f6>") #'ensime-format-source)

  (evil-mode 1)

  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode)
    (evil-leader/set-leader ",")
    (evil-leader/set-key
      ","  (lambda () (interactive) (ansi-term (getenv "SHELL")))
      ":" 'eval-expression
      "g" 'magit-status
      "w" 'save-buffer
      "S" 'delete-trailing-whitespace))

  ; https://github.com/timcharper/evil-surround
  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode))

)

;--------------------
; magit
;--------------------
(use-package magit
  :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (magit evil-surround evil-leader evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
