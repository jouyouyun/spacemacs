;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version          "0.200.9" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  ;; term and shell env
  (spacemacs/update-custom-envs)
  (global-set-key (kbd "C-c M-t") 'multi-term)
  ;; anzu
  (global-anzu-mode +1)
  (global-set-key (kbd "M-%") 'anzu-query-replace) ;
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)
  ;; avy
  (avy-setup-default)
  (setq avy-background t)
  (setq avy-style 'at-full)
  (setq avy-style 'at-full)
  (global-set-key (kbd "M-g w") 'avy-goto-char-in-line)
  (global-set-key (kbd "M-g f") 'avy-goto-char)
  (global-set-key (kbd "M-g g") 'avy-goto-line)
  (global-set-key (kbd "M-g C-y") 'avy-copy-line)
  (global-set-key (kbd "M-g C-k") 'avy-move-line)
  (global-set-key (kbd "M-g M-y") 'avy-copy-region)
  ;; c/c++ style
  (setq c-default-style "k&r"
        c-basic-offset 4
        tab-width 4
        indent-tabs-mode t)
  ;; magit
  (global-set-key (kbd "C-x g") 'magit-status)
  (require 'server)
  (unless (server-running-p) (server-start)))
