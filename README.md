# fffinder.el

## Description

`fffinder.el` allows you to find files quickly. It usesd `find`
or a similar tool to actually find the files and then just presents
them to the user for interactive selection.

This package depends on an external utility to do the file
search. By default, this is the POSIX-compliant `find` tool. However,
by setting `fffinder-command` as described below, this can be
adjusted.

## Installation

    (add-to-list 'load-path "/path/to/fffinder.el")
    (require 'fffinder)
    (global-set-key (kbd "C-c C-f") 'fffinder)
    
    ;; Optional - though somewhat recommended. See description.
    (fffinder-tweak-ido)
    
    ;; Optional
    (setq fffinder-command "find \! -iregex './.git.*'")
    
    ;; This command allows you to set which external tool to use for
    ;; finding files and which command line options to use along with
    ;; it.
    
    ;; Optinal
    ;; (global-set-key (kbd "C-c M-h") 'fffinder-set-root-here)

## Some Remarks

It is recommended to enable `ido`, if necessary, and set
`ido-decorations' to present the selection candidates vertically as
this is easier to skim with the eye.

Here is a sample `ido-decorations` setting along with some other
useful `ido` tweaks (if you do not want to set them yourself, call
`fffinder-tweak-ido` to do it for you - preferrably in one of your Emacs
setup files. For non-permanent tweaking, type `M-x fffinder-tweak-ido`):

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
    (setq ido-use-virtual-buffers nil)
