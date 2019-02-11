;; =======================================
;; Package archive: melpa
;; =======================================
;; 1. cmd: M-x list-packages
;; 2. key binding
;; i: mark for install
;; u: unmark, U: upgrade
;; d: make for deletion
;; x: execute deletion/install/upgrade
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/my_settings.org"))
