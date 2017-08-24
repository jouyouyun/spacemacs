;;; packages.el --- wen-editor layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <wen@Yun>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `wen-editor-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `wen-editor/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `wen-editor/pre-init-PACKAGE' and/or
;;   `wen-editor/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst wen-editor-packages
  '(
    easy-kill
    popup-kill-ring
    whole-line-or-region
    multiple-cursors
    youdao-dictionary
    ))


(defun wen-editor/init-popup-kill-ring()
  (use-package popup-kill-ring
    :init
    (progn
      (global-set-key (kbd "M-y") 'popup-kill-ring)
      )))

(defun wen-editor/init-easy-kill()
  (use-package easy-kill
    :init
    (progn
      ;; easy-kill
      ;; For example, M-w w saves current word, repeat w to expand the kill to
      ;; include the next word. 5 to include the next 5 words etc.
      ;; The other commands also follow this pattern.
      ;;
      ;; +/- does expanding/shrinking according to the thing selected.
      ;; So for word the expansion is word-wise, for line line-wise,
      ;; for list or sexp, list-wise.
      (global-set-key (kbd "M-s") 'easy-kill)
      (global-set-key [remap kill-ring-save] 'easy-kill)
      ;; default keybinding
      ;;  M-w w: save word at point
      ;;  M-w s: save sexp at point
      ;;  M-w l: save list at point (enclosing sexp)
      ;;  M-w d: save defun at point
      ;;  M-w D: save current defun name
      ;;  M-w f: save file at point
      ;;  M-w b: save buffer-file-name or default-directory.
      ;;         - changes the kill to the directory name,
      ;;         + to full name and 0 to basename.
      ;; The following keys modify the selection:
      ;;  @: append selection to previous kill and exit.
      ;;     For example, M-w d @ will append current function to last kill.
      ;;  C-w: kill selection and exit
      ;;  +, - and 1..9: expand/shrink selection
      ;;  0: shrink the selection to the intitial size i.e. before any expansion
      ;;  C-SPC: turn selection into an active region
      ;;  C-g: abort
      ;;  ?: help
      ;;
      ;; easy mark
      (global-set-key [remap mark-sexp] 'easy-mark)
      )))


;; Insert an empty line after the current line.
(defun wen-open-line(arg)
  (interactive "P")
  (if arg
      (wen-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))

;; Insert an empty line above the current line.
(defun wen-open-line-above()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

;; A simple wrapper around command `kill-whole-line' that
;; respects indentation.
;; Passes ARG to command `kill-whole-line' when provided.
(defun wen-kill-whole-line (&optional arg)
  (interactive "p")
  (kill-whole-line arg)
  (back-to-indentation))

;; Move point back to indentation of beginning of line.
;;
;; Move point to the first non-whitespace character on this line.
;; If point is already there, move to the beginning of the line.
;; Effectively toggle between the first non-whitespace character and
;; the beginning of the line.
;;
;; If ARG is not nil or 1, move forward ARG - 1 lines first.  If
;; point reaches the beginning or end of the buffer, stop there."
(defun wen-move-beginning-of-line (arg)
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(defun wen-delete-whole-word()
  ;; Move to begin of word, delete it
  (interactive)
  (backward-word 1)
  (kill-word 1))

(defun wen-editor/init-whole-line-or-region()
  (use-package whole-line-or-region
    :init
    (progn
      (global-set-key [remap kill-whole-line]
                      'wen-kill-whole-line)

      (global-set-key [remap move-beginning-of-line]
                      'wen-move-beginning-of-line)
      ;; Comment or uncomment
      (global-set-key (kbd "M-;") 'whole-line-or-region-comment-dwim-2)
      (global-set-key (kbd "M-w") 'whole-line-or-region-copy-region-as-kill)
      (global-set-key (kbd "C-c o") 'wen-open-line)
      (global-set-key (kbd "C-c O") 'wen-open-line-above)
      (global-set-key (kbd "C-c dd") 'wen-kill-whole-line)
      (global-set-key (kbd "C-c x") 'wen-delete-whole-word)
      )))

(defun wen-editor/init-multiple-cursors()
  (use-package multiple-cursors
    :init
    (progn
      ;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
      (global-set-key (kbd "C->") 'mc/mark-next-like-this)
      (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
      ;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
      (global-set-key (kbd "C-c C-s") 'mc/skip-to-next-like-this)
      )))

(defun wen-editor/init-youdao-dictionary()
  (use-package youdao-dictionary
    :init
    (progn
      ;; Enable Cache
      (setq url-automatic-caching t)
      (global-set-key (kbd "C-c M-\\") 'youdao-dictionary-search-at-point+)
      )))

;; search selected text
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))
