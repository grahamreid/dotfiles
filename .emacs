;; -------- GENERAL EMACS SETTINGS  ---------- ;;;; 

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (setq package-enable-at-startup nil)
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message nil)
  (setq package-list '(impatient-mode use-package flycheck cyberpunk-theme))
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("d1cc05d755d5a21a31bced25bed40f85d8677e69c73ca365628ce8024827c9e3" "38e64ea9b3a5e512ae9547063ee491c20bd717fe59d9c12219a0b1050b439cdd" default)))
 '(eshell-output-filter-functions
   (quote
    (eshell-handle-control-codes eshell-handle-ansi-color eshell-watch-for-password-prompt)))
 '(org-link-frame-setup
   (quote
    ((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame))))
 '(package-selected-packages
   (quote
    (pyvenv exec-path-from-shell linum-relative virtualenvwrapper hive js2-mode typescript-mode sr-speedbar json-mode magit emmet-mode matlab-mode impatient-mode use-package flycheck cyberpunk-theme)))
 '(python-shell-interpreter "python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

(setq explicit-shell-file-name "/usr/local/bin/zsh")

(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10.*\\)")
	))

(put 'erase-buffer 'disabled nil)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(tool-bar-mode -1)

(exec-path-from-shell-initialize)

;; -------- Window arrangement --------- ;;

(global-set-key (kbd "<M-down>") 'shrink-window)
(global-set-key (kbd "<M-up>") 'enlarge-window)
(global-set-key (kbd "<M-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<M-right>") 'enlarge-window-horizontally)

;; -------- MY SETTINGS FOR WEB DEV ---------- ;;

(use-package js2-mode :ensure t :defer t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.json\\'" . javascript-mode))
  :commands js2-mode
  :init (progn
          (setq-default js2-basic-offset 2
                        js2-indent-switch-body t
                        js2-auto-indent-p t
                        js2-global-externs '("angular")
                        js2-indent-on-enter-key t
                        flycheck-disabled-checkers '(javascript-jshint)
                        flycheck-checkers '(javascript-eslint)
                        flycheck-eslintrc "~/.eslintrc"))
  (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode))
)

;; ------- SQL settings ------ ;;

(setq sql-connection-alist
      '(
         (blank (sql-product 'postgres)
                  (sql-port 5432)
                  (sql-server "")
                  (sql-user "opal")
                  (sql-database "neo_corp_it"))
         (pg-local (sql-product 'postgres)
                  (sql-port 5432)
                  (sql-server "localhost")
                  (sql-user "grahamreid")
                  (sql-database "postgres"))
       )
)

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; Silence compiler warnings
(defvar sql-product)
(defvar sql-prompt-regexp)
(defvar sql-prompt-cont-regexp)

(add-hook 'sql-interactive-mode-hook 'my-sql-interactive-mode-hook)
(defun my-sql-interactive-mode-hook ()
  "Custom interactive SQL mode behaviours. See `sql-interactive-mode-hook'."
  (when (eq sql-product 'postgres)
    ;; Allow symbol chars in database names in prompt.
    ;; Default postgres pattern was: "^\\w*=[#>] " (see `sql-product-alist').
    (setq sql-prompt-regexp "^\\(?:\\sw\\|\\s_\\)*=[#>] ")
    ;; Ditto for continuation prompt: "^\\w*[-(][#>] "
    (setq sql-prompt-cont-regexp "^\\(?:\\sw\\|\\s_\\)*[-(][#>] "))

  ;; Deal with inline prompts in query output.
  ;; Runs after `sql-interactive-remove-continuation-prompt'.
  (add-hook 'comint-preoutput-filter-functions
            'my-sql-comint-preoutput-filter :append :local))

(defun my-sql-comint-preoutput-filter (output)
  "Filter prompts out of SQL query output.

Runs after `sql-interactive-remove-continuation-prompt' in
`comint-preoutput-filter-functions'."
  ;; If the entire output is simply the main prompt, return that.
  ;; (i.e. When simply typing RET at the sqli prompt.)
  (if (string-match (concat "\\`\\(" sql-prompt-regexp "\\)\\'") output)
      output
    ;; Otherwise filter all leading prompts from the output.
    ;; Store the buffer-local prompt patterns before changing buffers.
    (let ((main-prompt sql-prompt-regexp)
          (any-prompt comint-prompt-regexp) ;; see `sql-interactive-mode'
          (prefix-newline nil))
      (with-temp-buffer
        (insert output)
        (goto-char (point-min))
	(when (looking-at main-prompt)
          (setq prefix-newline t))
        (while (looking-at any-prompt)
          (replace-match ""))
        ;; Prepend a newline to the output, if necessary.
        (when prefix-newline
          (goto-char (point-min))
          (unless (looking-at "\n")
            (insert "\n")))
        ;; Return the filtered output.
        (buffer-substring-no-properties (point-min) (point-max))))))

(defadvice sql-send-string (before my-prefix-newline-to-sql-string)
  "Force all `sql-send-*' commands to include an initial newline.

This is a trivial solution to single-line queries tripping up my
custom output filter.  (See `my-sql-comint-preoutput-filter'.)"
  (ad-set-arg 0 (concat "\n" (ad-get-arg 0))))
(ad-activate 'sql-send-string)

(defun sql-find-sqli-buffer (&optional product connection)
  "Returns the name of the current default SQLi buffer or nil.
In order to qualify, the SQLi buffer must be alive, be in
`sql-interactive-mode' and have a process."
  (let ((buf  sql-buffer)
        (prod (or product sql-product)))
    (or
     ;; Current sql-buffer, if there is one.
     (and (sql-buffer-live-p buf prod connection)
          buf)
     ;; Global sql-buffer
     (and (setq buf (default-value 'sql-buffer))
          (sql-buffer-live-p buf prod connection)
          buf)
     ;; Look thru each buffer
     (car (apply 'append
                 (mapcar (lambda (b)
                           (and (sql-buffer-live-p b prod connection)
                                (list (buffer-name b))))
                         (buffer-list)))))))

;; (setq url-proxy-services '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;;                            ("http" . "")
;;  			   ("https" . "")
;;  			   ))

;; ------------ KBDs ------------- ;;

(global-set-key (kbd "C-c p") 'python-shell-send-buffer)
(global-set-key (kbd "C-c v") 'pyvenv-activate)
