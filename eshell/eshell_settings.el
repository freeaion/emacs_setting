(use-package eshell
  :config
  (defun ha/eshell-quit-or-delete-char (arg)
    (interactive "p")
    (if (and (eolp) (looking-back eshell-prompt-regexp))
        (progn
          (eshell-life-is-too-much) ; Why not? (eshell/exit)
          (ignore-errors
            (delete-window)))
      (delete-forward-char arg)))
  (setq tramp-default-method "ssh")
  :init
  (setq ;; eshell-buffer-shorthand t ...  Can't see Bug#19391
   eshell-scroll-to-bottom-on-input 'all
   eshell-error-if-no-glob t
   eshell-hist-ignoredups t
   eshell-save-history-on-exit t
   eshell-prefer-lisp-functions nil
   eshell-destroy-buffer-when-process-dies t)
  (add-hook 'eshell-mode-hook
            (lambda ()
              (bind-keys :map eshell-mode-map
                         ("C-d" . ha/eshell-quit-or-delete-char))
              (bind-keys :map eshell-mode-map
                         ([up] . previous-line))
              (bind-keys :map eshell-mode-map
                         ([down] . next-line))

              ;;(define-key eshell-mode-map [up] 'previous-line)
              ;;(define-key eshell-mode-map [down] 'next-line)

              (add-to-list 'eshell-visual-commands "ssh")
              (add-to-list 'eshell-visual-commands "tail")
              (add-to-list 'eshell-visual-commands "top")
              (eshell/alias "e" "find-file $1")
              (eshell/alias "ff" "find-file $1")
              (eshell/alias "emacs" "find-file $1")
              (eshell/alias "ee" "find-file-other-window $1")

              (eshell/alias "gd" "magit-diff-unstaged")
              (eshell/alias "gds" "magit-diff-staged")
              (eshell/alias "d" "dired $1")

              ;; The 'ls' executable requires the Gnu version on the Mac
              (let ((ls (if (file-exists-p "/usr/local/bin/gls")
                            "/usr/local/bin/gls"
                          "/bin/ls")))
                (eshell/alias "ll" (concat ls " -AlohG --color=always")))))
  )

(use-package eshell-bookmark
  :ensure t
  :after eshell
  :config
  (add-hook 'eshell-mode-hook #'eshell-bookmark-setup))

(use-package eshell-z
  :ensure t
  :after eshell
  :config
  (add-hook 'eshell-mode-hook
            (defun my-eshell-mode-hook ()
              (require 'eshell-z))))

(setenv "PATH"
        (concat
         "/usr/local/bin:/usr/local/sbin:"
         (getenv "PATH")))

(setenv "PAGER" "cat")

(defun eshell/f (filename &optional dir try-count)
  "Searches for files matching FILENAME in either DIR or the
current directory. Just a typical wrapper around the standard
`find' executable.

Since any wildcards in FILENAME need to be escaped, this wraps the shell command.

If not results were found, it calls the `find' executable up to
two more times, wrapping the FILENAME pattern in wildcat
matches. This seems to be more helpful to me."
  (let* ((cmd (concat
               (executable-find "find")
               " " (or dir ".")
               "      -not -path '*/.git*'"
               " -and -not -path '*node_modules*'"
               " -and -not -path '*classes*'"
               " -and "
               " -type f -and "
               "-iname '" filename "'"))
         (results (shell-command-to-string cmd)))

    (if (not (s-blank-str? results))
        results
      (cond
       ((or (null try-count) (= 0 try-count))
        (eshell/f (concat filename "*") dir 1))
       ((or (null try-count) (= 1 try-count))
        (eshell/f (concat "*" filename) dir 2))
       (t "")))))

(defun eshell/ef (filename &optional dir)
  "Searches for the first matching filename and loads it into a
file to edit."
  (let* ((files (eshell/f filename dir))
         (file (car (s-split "\n" files))))
    (find-file file)))

(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun curr-dir-git-branch-string (pwd)
  "Returns current git branch as a string, or the empty string if
PWD is not in a git repo (or the git command is not found)."
  (interactive)
  (when (and (not (file-remote-p pwd))
             (eshell-search-path "git")
             (locate-dominating-file pwd ".git"))
    (let* ((git-url (shell-command-to-string "git config --get remote.origin.url"))
           (git-repo (file-name-base (s-trim git-url)))
           (git-output (shell-command-to-string (concat "git rev-parse --abbrev-ref HEAD")))
           (git-branch (s-trim git-output))
           (git-icon  "\xe0a0")
           (git-icon2 (propertize "\xf020" 'face `(:family "octicons"))))
      (concat git-repo " " git-icon2 " " git-branch))))

(defun pwd-replace-home (pwd)
  "Replace home in PWD with tilde (~) character."
  (interactive)
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun pwd-shorten-dirs (pwd)
  "Shorten all directory names in PWD except the last two."
  (let ((p-lst (split-string pwd "/")))
    (if (> (length p-lst) 2)
        (concat
         (mapconcat (lambda (elm) (if (zerop (length elm)) ""
                               (substring elm 0 1)))
                    (butlast p-lst 2)
                    "/")
         "/"
         (mapconcat (lambda (elm) elm)
                    (last p-lst 2)
                    "/"))
      pwd)))  ;; Otherwise, we just return the PWD

(defun split-directory-prompt (directory)
  (if (string-match-p ".*/.*" directory)
      (list (file-name-directory directory) (file-name-base directory))
    (list "" directory)))

(defun ruby-prompt ()
  "Returns a string (may be empty) based on the current Ruby Virtual Environment."
  (let* ((executable "~/.rvm/bin/rvm-prompt")
         (command    (concat executable "v g")))
    (when (file-exists-p executable)
      (let* ((results (shell-command-to-string executable))
             (cleaned (string-trim results))
             (gem     (propertize "\xe92b" 'face `(:family "alltheicons"))))
        (when (and cleaned (not (equal cleaned "")))
          (s-replace "ruby-" gem cleaned))))))

(defun python-prompt ()
  "Returns a string (may be empty) based on the current Python
   Virtual Environment. Assuming the M-x command: `pyenv-mode-set'
   has been called."
  (when (fboundp #'pyenv-mode-version)
    (let ((venv (pyenv-mode-version)))
      (when venv
        (concat
         (propertize "\xe928" 'face `(:family "alltheicons"))
         (pyenv-mode-version))))))

(defun eshell/eshell-local-prompt-function ()
  "A prompt for eshell that works locally (in that is assumes
that it could run certain commands) in order to make a prettier,
more-helpful local prompt."
  (interactive)
  (let* ((pwd        (eshell/pwd))
         (directory (split-directory-prompt
                     (pwd-shorten-dirs
                      (pwd-replace-home pwd))))
         (parent (car directory))
         (name   (cadr directory))
         (branch (curr-dir-git-branch-string pwd))
         (ruby   (when (not (file-remote-p pwd)) (ruby-prompt)))
         (python (when (not (file-remote-p pwd)) (python-prompt)))

         (dark-env (eq 'dark (frame-parameter nil 'background-mode)))
         (for-bars                 `(:weight bold))
         (for-parent  (if dark-env `(:foreground "dark orange") `(:foreground "blue")))
         (for-dir     (if dark-env `(:foreground "orange" :weight bold)
                        `(:foreground "blue" :weight bold)))
         (for-git                  `(:foreground "green"))
         (for-ruby                 `(:foreground "red"))
         (for-python               `(:foreground "#5555FF")))

    (concat
     (propertize "⟣─ "    'face for-bars)
     (propertize parent   'face for-parent)
     (propertize name     'face for-dir)
     (when branch
       (concat (propertize " ── "    'face for-bars)
               (propertize branch   'face for-git)))
     (when ruby
       (concat (propertize " ── " 'face for-bars)
               (propertize ruby   'face for-ruby)))
     (when python
       (concat (propertize " ── " 'face for-bars)
               (propertize python 'face for-python)))
     (propertize "\n"     'face for-bars)
     (propertize (if (= (user-uid) 0) " #" " $") 'face `(:weight ultra-bold))
     (propertize " "    'face `(:weight bold)))))

(setq-default eshell-prompt-function #'eshell/eshell-local-prompt-function)
(setq eshell-highlight-prompt nil)

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(bind-key "C-!" 'eshell-here)

(defun ha/eshell-host->tramp (username hostname &optional prefer-root)
  "Returns a TRAMP reference based on a USERNAME and HOSTNAME
that refers to any host or IP address."
  (cond ((string-match-p "^/" host)
           host)
        ((or (and prefer-root (not username)) (equal username "root"))
           (format "/ssh:%s|sudo:%s:" hostname hostname))
        ((or (null username) (equal username user-login-name))
           (format "/ssh:%s:" hostname))
        (t
           (format "/ssh:%s|sudo:%s|sudo@%s:%s:" hostname hostname username hostname))))

(defun ha/eshell-host-regexp (regexp)
  "Returns a particular regular expression based on symbol, REGEXP"
  (let* ((user-regexp      "\\(\\([[:alpha:].]+\\)@\\)?")
         (tramp-regexp     "\\b/ssh:[:graph:]+")
         (ip-char          "[[:digit:]]")
         (ip-plus-period   (concat ip-char "+" "\\."))
         (ip-regexp        (concat "\\(\\(" ip-plus-period "\\)\\{3\\}" ip-char "+\\)"))
         (host-char        "[[:alpha:][:digit:]-]")
         (host-plus-period (concat host-char "+" "\\."))
         (host-regexp      (concat "\\(\\(" host-plus-period "\\)+" host-char "+\\)"))
         (horrific-regexp  (concat "\\b"
                                   user-regexp ip-regexp
                                   "\\|"
                                   user-regexp host-regexp
                                   "\\b")))
    (cond
     ((eq regexp 'tramp) tramp-regexp)
     ((eq regexp 'host)  host-regexp)
     ((eq regexp 'full)  horrific-regexp))))

(defun eshell-there (host)
  "Creates an eshell session that uses Tramp to automatically
connect to a remote system, HOST.  The hostname can be either the
IP address, or FQDN, and can specify the user account, as in
root@blah.com. HOST can also be a complete Tramp reference."
  (interactive "sHost: ")

  (let* ((default-directory
           (cond
            ((string-match-p "^/" host) host)

            ((string-match-p (ha/eshell-host-regexp 'full) host)
             (string-match (ha/eshell-host-regexp 'full) host) ;; Why!?
             (let* ((user1 (match-string 2 host))
                    (host1 (match-string 3 host))
                    (user2 (match-string 6 host))
                    (host2 (match-string 7 host)))
               (if host1
                   (ha/eshell-host->tramp user1 host1)
                 (ha/eshell-host->tramp user2 host2))))

            (t (format "/%s:" host)))))
    (eshell-here)))
