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
(setq package-archive-priorities '(("gnu" . 10)
                                   ("melpa" . 5))
      package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://stable.melpa.org/packages/")
                         ("melpa-devel" . "https://melpa.org/packages/")))
(package-initialize)

(org-babel-load-file (expand-file-name "~/.emacs.d/my_settings.org"))

