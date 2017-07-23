;;; fffinder.el --- Find files, quickly            -*- lexical-binding: t; -*-

;; Copyright (C) XXXX  -

;; Author: - <xxx@xxx.xxx>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; `fffinder.el' allows you to find files quickly. It usesd `find'
;; or a similar tool to actually find the files and then just presents
;; them to the user for interactive selection.
;;
;; This package depends on an external utility to do the actual file
;; search. By default, this is the POSIX-compliant `find' tool. However,
;; by setting `fffinder-command' as described below, this can be
;; adjusted.
;;
;; Installation:
;;
;;   (add-to-list 'load-path "/path/to/fffinder.el")
;;   (require 'fffinder)
;;   (global-set-key (kbd "C-c C-f") 'fffinder)
;;
;;   ;; Optional - though somewhat recommended. See description.
;;   (fffinder-tweak-ido)
;;
;;   ;; Optional
;;   (setq fffinder-command "find \! -iregex './.git.*'")
;;
;;   ;; This command allows you to set which external tool to use for
;;   ;; finding files and which command line options to use along with
;;   ;; it.
;;
;;   ;; Optinal
;;   ;; (global-set-key (kbd "C-c M-h") 'fffinder-set-root-here)
;;
;; It is recommended to enable `ido', if necessary, and set
;; `ido-decorations' to present the selection candidates vertically as
;; this is easier to skim with the eye.
;;
;; Here is a sample `ido-decorations' setting along with some other
;; useful `ido' tweaks (if you do not want to set them yourself, call
;; `fffinder-tweak-ido' to do it for you - preferrably in one of your
;; Emacs setup files. For non-permanent tweaking, type
;; `M-x fffinder-tweak-ido'):
;;
;;   (setq ido-decorations
;;         (quote ("\n>> " "" "\n   " "\n   ..." "[" "]"
;;   	      " [No match]" " [Matched]" " [Not readable]"
;;   	      " [Too big]" " [Confirm]")))
;;   (defun ido-disable-line-truncation ()
;;     (set (make-local-variable 'truncate-lines) nil))
;;   (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
;;   (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
;;     (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
;;     (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
;;   (add-hook 'ido-setup-hook 'ido-define-keys)
;;   (setq ido-max-prospects 50)
;;   (setq ido-max-window-height 0.75)
;;   (setq ido-use-virtual-buffers nil)


;;; Code:



(provide 'fffinder)


(defvar fffinder-command "find \! -iregex './.git.*'")

(defvar fffinder-root nil)

(defun fffinder-set-root-here ()
  (interactive)
  (setq fffinder-root default-directory))

(defun fffinder-set-root (project-root)
  (interactive "DSet fffinder project root: ")
  (setq fffinder-root project-root))

(defun fffinder ()
  (interactive)
  (if (eq fffinder-root nil)
      (call-interactively 'fffinder-set-root)
    (with-temp-buffer
      (cd fffinder-root)
      (find-file
       (ido-completing-read
        "Find file or dir: "
        (split-string
         (shell-command-to-string fffinder-command) "\n"))))))

;; This is a convenience function. It is not strictly necessary for
;; `fffinder' to work, but once it has been called, both `fffinder' and
;; `ido' feel so much more comfortable.
(defun fffinder-tweak-ido ()
  "Tweak `ido' to behave a bit more intuitive. Set it so selection lists
are displayed vertically. Add `C-p' and `C-n' as keybindings to select
the previous/next entry and perform some other minor adjustments."
  (interactive)
  (setq ido-decorations
        (quote ("\n>> " "" "\n   " "\n   ..." "[" "]"
                " [No match]" " [Matched]" " [Not readable]"
                " [Too big]" " [Confirm]")))
  (defun ido-disable-line-truncation ()
    (set (make-local-variable 'truncate-lines) nil))
  (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
  (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
    (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
    (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
  (add-hook 'ido-setup-hook 'ido-define-keys)
  (setq ido-max-prospects 50)
  (setq ido-max-window-height 0.75)
  (setq ido-use-virtual-buffers nil))

;;; fffinder.el ends here
