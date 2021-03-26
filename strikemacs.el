;;;; Strikemacs config file
;;; Date created: 16th Feb, 2021 by StrikeWizard
;;; Last Modified: 16th Feb, 2021 by StrikeWizard

;;; Formatting, visual improvements

;;; TODO:

;; magit 
;; projectile 
;; helm 
;; company 
;; markdown
;; popup 

    (add-to-list 'default-frame-alist '(height . 20))
    (add-to-list 'default-frame-alist '(width . 100))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'company-mode)

(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)

(ac-config-default)
(require 'ac-geiser)
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)

(show-paren-mode 1)

(tool-bar-mode -1)
(menu-bar-mode -1)
;(set-scroll-bar-mode 'right)

(setq visible-bell t)
(setq ring-bell-function 'ignore)

(setq scroll-conservatively 100)

(global-prettify-symbols-mode t)

(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))
(electric-pair-mode t)

(global-hl-line-mode t)

(use-package evil
  :ensure t
  :defer nil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

 (require 'powerline)
 (powerline-center-evil-theme)

;;; Movement and frame enhancements

(defun split-and-follow-horizontally ()
	(interactive)
	(split-window-below)
	(balance-windows)
	(other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
	(interactive)
	(split-window-right)
	(balance-windows)
	(other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)

(global-set-key (kbd "TAB") 'company-complete)

(use-package switch-window
	:ensure t
	:config
	(setq switch-window-input-style 'minibuffer)
	(setq switch-window-increase 4)
	(setq switch-window-threshold 2)
	(setq switch-window-shortcut-style 'qwerty)
	(setq switch-window-qwerty-shortcuts
		  '("z" "x" "c" "v" "a" "s" "d" "f"))
	:bind
	([remap other-window] . switch-window))

;; TODO: checkout ido

;;; Org mode

;; TODO: improve, customize Org
;; TODO: check out Org-roam

(use-package org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            '(lambda ()
               (visual-line-mode 1))))

(setq org-hide-emphasis-markers t)

(use-package org-indent
  :diminish org-indent-mode)

(use-package htmlize
  :ensure t)

;;; Misc enhancements

;; TODO: eshell enhancement
(setq eshell-prompt-function
      (lambda nil
	(concat
	 (propertize (eshell/pwd) 'face `(:foreground "#6b83ac"))
	 (propertize " ε " 'face `(:foreground "#8f8f8f")))))
(setq eshell-highlight-prompt nil)

(setq x-select-enable-clipboard t)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))

(use-package async
  :ensure t
  :init
  (dired-async-mode 1))

(use-package swiper
  :ensure t
  :bind ("C-s" . 'swiper))

;; TODO: checkout magit
;; TODO: checkout eldoc
(global-undo-tree-mode)

;;; Code section

;; TODO: configure company

(setq inferior-lisp-program "sbcl")
(require 'slime)
(add-hook 'slime-mode-hook
          (lambda ()
            (unless (slime-connected-p)
              (save-excursion (slime)))))

(slime-setup '(slime-fancy slime-company))

(use-package slime-company
  :after (slime company)
  :config (setq slime-company-completion 'fuzzy))

;; TODO: configure yasnippet

;;; Dashboard

(use-package dashboard
  :ensure t
  :defer nil
  :preface
  (defun create-scratch-buffer ()
    "Create a scratch buffer"
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents . 3)))
; (add-to-list 'dashboard-items '(agenda) t)
  (setq dashboard-banner-logo-title "S T R I K E M A C S") ; "ストライクマックス"
  (setq dashboard-startup-banner "~/.emacs.d/strikevec.png")
; (setq dashboard-startup-banner 'official)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-set-init-info t)
  (setq dashboard-init-info (format "%d packages loaded in %s"
                                    (length package-activated-list) (emacs-init-time)))
  (setq dashboard-set-footer nil)
  (setq dashboard-set-navigator t)
  (setq dashboard-navigator-buttons
        `(
          ((,nil
            "Open scratch buffer"
            "Switch to the scratch buffer"
            (lambda (&rest _) (create-scratch-buffer))
            'default)
           (nil
            "Open strikemacs.el"
	    "Open Strikemacs' configuration file"
            (lambda (&rest _) (find-file "~/.emacs.d/strikemacs.el"))
            'default)
	   (nil
            "Record book progress"
	    "Open book-progress.org"
            (lambda (&rest _) (find-file "~/.emacs.d/book-progress.org"))
            'default)))))

