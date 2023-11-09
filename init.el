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

(org-babel-load-file (expand-file-name "~/.emacs.d/my_settings.org"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(company-dabbrev-code-ignore-case t)
 '(company-quickhelp-mode t)
 '(current-language-environment "UTF-8")
 '(delete-selection-mode t)
 '(desktop-save-mode t)
 '(dired-listing-switches "-al --group-directories-first")
 '(display-time-mode t)
 '(ediff-split-window-function
   (lambda
     (&optional arg)
     (if
         (>
          (frame-width)
          150)
         (split-window-horizontally arg)
       (split-window-vertically arg))) t)
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(elscreen-default-buffer-name "new_elscreen")
 '(elscreen-display-tab nil)
 '(elscreen-tab-display-control nil)
 '(fill-column 80)
 '(frame-title-format "emacs - %b" t)
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(global-visual-line-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(isearch-highlight t)
 '(magit-log-section-arguments '("--graph" "--color" "--decorate" "-n32"))
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(next-line-add-newlines nil)
 '(package-enable-at-startup nil)
 '(package-selected-packages
   '(tree-sitter-langs bazel kotlin-mode rustic markdown-mode docker-compose-mode dockerfile-mode js2-mode tide typescript-mode which-key org-bullets magit hydra flycheck deft dashboard helm-swoop helm-projectile helm-company helm-ag helm zoom-window volatile-highlights elscreen diminish buffer-move ample-theme ws-butler undo-tree symbol-overlay origami multiple-cursors highlight-parentheses expand-region yasnippet company-quickhelp company avy multi-vterm vterm))
 '(projectile-completion-system 'helm)
 '(projectile-mode t nil (projectile))
 '(projectile-switch-project-action 'helm-projectile-switch-to-buffer)
 '(projectile-tags-backend 'find-tag)
 '(projectile-tags-command "")
 '(projectile-tags-file-name "")
 '(query-replace-highlight t)
 '(scroll-conservatively 1)
 '(scroll-preserve-screen-position t)
 '(scroll-step 1)
 '(show-paren-mode t)
 '(show-paren-style 'expression)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(whitespace-style
   '(face trailing tabs spaces lines lines-tail empty indentation::tab indentation::space indentation tab-mark))
 '(x-select-enable-clipboard-manager t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
