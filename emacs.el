(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)

(setq custom-file "~/.config/emacs/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Function to install packages if they're not already installed
(defvar my-packages
  '(go-mode yaml-mode web-mode markdown-mode tree-sitter tree-sitter-langs
    editorconfig company drag-stuff eglot helm elfeed crux))

(defun install-my-packages ()
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package my-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-my-packages)

;; General stuff
(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq visible-bell t)
(setq echo-keystrokes 0.1)
(setq gc-cons-threshold 20000000)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)
(setq-default tab-width 4)
(setq-default truncate-lines t)
(set-default 'indicate-empty-lines t)
(setq electric-pair-preserve-balance nil)
(setq byte-compile-warnings '(cl-functions))
(global-display-line-numbers-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode t)
(show-paren-mode 1)
(setq-default fill-column 80)
(global-hl-line-mode 1)
(set-face-background hl-line-face "gray13")
(add-to-list 'default-frame-alist '(foreground-color . "#ffffff"))
(add-to-list 'default-frame-alist '(background-color . "#151515"))

;; Key rebinds
(global-set-key (kbd "C-z") 'undo-only)
(global-set-key (kbd "C-S-z") 'undo-redo)
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "M-f") 'fill-paragraph)
(global-set-key (kbd "C-x C-c") 'kill-emacs)
(global-set-key (kbd "M-q") 'kill-emacs)
(global-set-key (kbd "M-<right>") 'end-of-line)
(global-set-key (kbd "M-<left>") 'beginning-of-line)
(global-set-key (kbd "M-d") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "M-k") 'crux-kill-whole-line)
(global-set-key (kbd "C-h") 'crux-kill-line-backwards)
(global-set-key (kbd "C-k") 'crux-kill-other-buffers)
(global-set-key (kbd "M-v") 'visual-line-mode)
(global-set-key (kbd "C-_") (lambda() (interactive) (comment-line 1) (previous-line 1)))

;; Move line up and down
(drag-stuff-mode t)
(global-set-key (kbd "M-<up>") 'drag-stuff-up)
(global-set-key (kbd "M-<down>") 'drag-stuff-down)

;; Save a list of recent files visited. (open recent file with C-x f)
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Helm stuff
(require 'helm)
(helm-autoresize-mode 1) 
(setq helm-autoresize-max-height 25 helm-autoresize-min-height 25)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-p") 'helm-find-files)
(global-set-key (kbd "C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-_") 'helm-find)

;; Enables editorconfig
(editorconfig-mode 1)

;; Enable company mode completion
(add-hook 'after-init-hook 'global-company-mode)

;; Eglot LSP
(setq eglot-ignored-server-capabilities '(:inlayHintProvider))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'tcl-mode-hook 'eglot-ensure)
(add-hook 'sh-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'lua-mode-hook 'eglot-ensure)
(add-hook 'js-mode-hook 'eglot-ensure)

;; Go format before save
(add-hook 'go-mode-hook
  (lambda ()
    (add-hook 'before-save-hook 'gofmt-before-save)
    (setq tab-width 4)
    (setq indent-tabs-mode 1)))

;; Enables tree sitter
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

;; Templating engines
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.django\\'" . web-mode))
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
;; (setq web-mode-enable-auto-pairing t)
;; (setq web-mode-enable-auto-closing t)

;; RSS Feeds
(setq elfeed-search-filter "@48-months-ago")
(setq elfeed-feeds '(
  ("https://landley.net/rss.xml")
  ("https://blog.regehr.org/feed")
  ("https://szymonkaliski.com/feed.xml")
  ("https://world.hey.com/dhh/feed.atom")
  ("https://workchronicles.com/feed/")
  ("https://mitchellh.com/feed.xml")
  ("https://matt-rickard.com/rss")
  ("https://solar.lowtechmagazine.com/posts/index.xml")
  ("https://utcc.utoronto.ca/~cks/space/blog/?atom")
  ("https://gosamples.dev/index.xml")
  ("https://neil.computer/rss/")
  ("https://matduggan.com/rss/")
  ("https://michael.stapelberg.ch/feed.xml")
  ("https://offbeatpursuit.com/blog/index.rss")
  ("https://offbeatpursuit.com/paste/index.rss")
  ("https://offbeatpursuit.com/notes/index.rss")
  ("https://emacsredux.com/atom.xml")
  ("https://journal.valeriansaliou.name/rss/")
  ("https://www.taniarascia.com/rss.xml")
  ("https://crawl.develz.org/wordpress/feed")
  ("https://snarky.ca/rss/")
  ("https://www.jeffgeerling.com/blog.xml")
  ("https://serokell.io/blog.rss.xml")
  ("https://www.duskborn.com/index.xml")
  ("https://mirzapandzo.com/rss.xml")
  ("https://blog.boot.dev/index.xml")
  ("https://macwright.com/rss.xml")
))

