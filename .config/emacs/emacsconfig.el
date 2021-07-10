;; This is my actual init.el file, my original init.el only consists of
;; (load "~/.config/emacs/emacsconfig.el")
;; Did this because my dotfiles repo did Not like the .emacs.d directory, oh well.

(setq default-korean-keyboard "3f")

(with-eval-after-load "quail"
  (push
   (cons "dvorak"
	 (concat
	  "                              "
	  "`~1!2@3#4$5%6^7&8*9(0)[{]}    "   ; numbers
	  "  '\",<.>pPyYfFgGcCrRlL/?=+\\|  " ; qwerty
	  "  aAoOeEuUiIdDhHtTnNsS-_      "   ; asdf
	  "  ;:qQjJkKxXbBmMwWvVzZ        "   ; zxcv
	  "                              "))
   quail-keyboard-layout-alist)

  (quail-set-keyboard-layout "dvorak"))

(with-eval-after-load "quail/hangul"
  (defun hangul3-input-method (key)
    "3-Bulsik final input method."
    (setq key (quail-keyboard-translate key))
    (if (or buffer-read-only (< key 33) (>= key 127))
	(list key)
      (quail-setup-overlays nil)
      (let ((input-method-function nil)
            (echo-keystrokes 0)
            (help-char nil))
	(setq hangul-queue (make-vector 6 0))
	(hangul3-input-method-internal key)
	(unwind-protect
            (catch 'exit-input-loop
              (while t
		(let* ((seq (read-key-sequence nil))
                       (cmd (lookup-key hangul-im-keymap seq))
                       key)
                  (cond ((and (stringp seq)
                              (= 1 (length seq))
                              (setq key (quail-keyboard-translate (aref seq 0)))
                              (and (>= key 33) (< key 127)))
			 (hangul3-input-method-internal key))
			((commandp cmd)
			 (call-interactively cmd))
			(t
			 (setq unread-command-events
                               (nconc (listify-key-sequence seq)
                                      unread-command-events))
			 (throw 'exit-input-loop nil))))))
          (quail-delete-overlays)))))
  )

(require 'mu4e)

(setq mu4e-change-filenames-when-moving t)

;; make text flow in mu4e composition
(setq mu4e-compose-format-flowed t)

(require 'gnus-dired
	 )
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
	(set-buffer buffer)
	(when (and (derived-mode-p 'message-mode)
		(null message-sent-message-via))
	  (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

;; for personal information
(load "~/.emacs.d/secrets")

;; for sudo in dired
(load "~/.emacs.d/lisp/dired-toggle-sudo/dired-toggle-sudo.el")

(require 'dired-toggle-sudo)
(define-key dired-mode-map (kbd "C-c C-o") 'dired-toggle-sudo)

(eval-after-load 'tramp
 '(progn
    ;; Allow to use: /sudo:user@host:/path/to/file
    (add-to-list 'tramp-default-proxies-alist
	  '(".*" "\\`.+\\'" "/ssh:%h:"))))

;; set some fonts
(set-face-attribute 'default nil :family "Source Code Pro")

(set-face-attribute 'default nil :height 150)

(set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))

;; setting hanja fonts
(set-fontset-font t '(#x3300 . #x9FFF) (font-spec :name "Noto Serif CJK KR"))

(set-fontset-font t '(#xF900 . #xFAFF) (font-spec :name "Noto Serif CJK KR"))

(set-fontset-font t '(#x20000 . #x2A6DF) (font-spec :name "Noto Serif CJK KR"))

(set-fontset-font t '(#x2F800 . #x2F98F) (font-spec :name "Noto Serif CJK KR"))

;; global keybindings
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c m") 'mu4e)
(global-set-key (kbd "C-c t") 'vterm)
(global-set-key (kbd "C-c w") 'count-words)
(global-set-key (kbd "C-s") 'save-buffer)

;; change focus between Emacs windows
(global-set-key (kbd "s-<left>") 'windmove-left)
(global-set-key (kbd "s-<right>") 'windmove-right)
(global-set-key (kbd "s-<up>") 'windmove-up)
(global-set-key (kbd "s-<down>") 'windmove-down)

(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-l") 'windmove-right)
(global-set-key (kbd "s-k") 'windmove-up)
(global-set-key (kbd "s-j") 'windmove-down)

;; delete current window
(global-set-key (kbd "s-q") 'delete-window)
;; delete all other windows
(global-set-key (kbd "s-a") 'delete-other-windows)
;; switch buffer
(global-set-key (kbd "s-s") 'switch-to-buffer)
;; find file
(global-set-key (kbd "s-f") 'find-file)
;; open buffer in right window? - tbc
;; open recent file?

(setq inhibit-splash-screen t)

(defun lj-emacsclient-faces ()
  "Setting up my default appearances when opening with emacsclient"
  (interactive)
  (load-theme 'zenburn t)
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 150)
  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))
  (set-fontset-font t '(#x3300 . #x9FFF) (font-spec :name "Noto Serif CJK KR"))
  (set-fontset-font t '(#xF900 . #xFAFF) (font-spec :name "Noto Serif CJK KR"))
  (set-fontset-font t '(#x20000 . #x2A6DF) (font-spec :name "Noto Serif CJK KR"))
  (set-fontset-font t '(#x2F800 . #x2F98F) (font-spec :name "Noto Serif CJK KR"))
  (setq doom-modeline-icon t)
)

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (select-frame frame)
            (lj-emacsclient-faces)))

(setq org-capture-templates
      '(("t" "Todo" entry (file+olp+datetree "~/Documents/records/journal.org")
         "* TODO %^{PROMPT} %^g\n SCHEDULED: %t %i\n %a\n %?" :jump-to-captured t :unnarrowed t)
        ("b" "Blog" entry (file+headline "~/Documents/website/blog/posts.org" "Drafts")
         "* TODO %^{PROMPT}\n :PROPERTIES:\n :EXPORT_DATE: %t\n :EXPORT_FILE_NAME: %?\n :EXPORT_HUGO_CUSTOM_FRONT_MATTER: :summary \"\" :showToc \"True\" :TocOpen \"True\"\n :END:\n #+ATTR_HTML::alt \n#+CAPTION: #+begin_src bash -n\n #+end_src" :jump-to-captured t :unnarrowed t :empty-lines-after: 1)))

;;(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/color-theme-6.6.0/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(require 'color-theme)

(load-theme 'zenburn t)

(menu-bar-mode -1)
(tool-bar-mode -1)

  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)

(setq evil-want-integration t)
(setq evil-want-keybinding nil)

(defun lj-org-mode-hook ()
  (olivetti-mode +1)
  (org-bullets-mode +1)
)

(require 'org-bullets)
(setq org-bullets-face-name (quote bulletface))
(setq org-bullets-bullet-list '("✿"))
(set-face-attribute 'org-level-1 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-2 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-3 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-4 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-5 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-6 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-7 nil :family "Noto Sans CJK KR")
(set-face-attribute 'org-level-8 nil :family "Noto Sans CJK KR")

;; advise org-agenda-switch-to to open window to right
(advice-add 'org-agenda-switch-to :before #'windmove-display-right)

(add-to-list 'load-path "~/.emacs.d/lisp/evil-org-mode")
(require 'evil-org)

(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

(add-hook 'org-mode-hook #'lj-org-mode-hook)
(require 'evil)
(evil-mode 1)
(setq evil-undo-system 'undo-fu)

(require 'undo-fu)
(define-key evil-normal-state-map "u" 'undo-fu-only-undo)
(define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo)

(when (require 'evil-collection nil t)
  (evil-collection-init))

(setq default-directory "~/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(completion-category-overrides '((file (styles basic substring))))
 '(completion-ignore-case t t)
 '(completion-styles '(basic partial-completion substring initials flex))
 '(custom-safe-themes
   '("eaf2f93b9943a39461e1d5a1ea454ba8d65071513639885912a4b2e1cb3b44cb" "db003d96cd620a8a5a9578ae31716a2bf3f36362cc2857fc976e8fae8c134551" "2dd4d767f6b2086cbf89353ba582716ce4023d0c00c9bb08459124a83a4d482f" "536cf039c902ba828951d364d06c9989af02441fd51f0a94ce176995901540b8" "efcfd4b6b29c56e657b29caca5906d53cffc5a107bcdae41a33b8431699ea09a" "bda6d86a437b336294abef6b7f11b0ddf11da1da0066f4d7d5c38736cd60813f" default))
 '(fci-rule-color "#383838")
 '(icomplete-hide-common-prefix nil)
 '(icomplete-mode t)
 '(icomplete-prospects-height 5)
 '(icomplete-show-matches-on-no-input t)
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-agenda-files
   '("/home/lj/Documents/records/journal.org" "/home/lj/Documents/writing/soseono/draft.org"))
 '(package-selected-packages
   '(elpher doom-modeline org-bullets vterm undo-fu-session ox-hugo undo-fu pdf-tools dired-toggle-sudo emms olivetti evil-collection magit evil))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(read-buffer-completion-ignore-case t)
 '(read-file-name-completion-ignore-case t)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3" t))
  (define-key icomplete-minibuffer-map (kbd "<return>") 'icomplete-force-complete-and-exit)

(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(defun er-sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo::root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo::root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-c o") #'er-sudo-edit)

(require 'dired-x)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(setq dired-guess-shell-alist-user '(
				   ("\\.pdf$" "mupdf")
                                   ("\\.doc\\'" "libreoffice")
                                   ("\\.docx\\'" "libreoffice")
                                   ("\\.odt\\'" "libreoffice")
                                   ("\\.odg\\'" "libreoffice")
                                   ("\\.ppt\\'" "libreoffice")
                                   ("\\.pptx\\'" "libreoffice")
                                   ("\\.xls\\'" "libreoffice")
                                   ("\\.xlsx\\'" "libreoffice")
                                   ("\\.jpg\\'" "feh -.")
                                   ("\\.jpeg\\'" "feh -.")
                                   ("\\.png\\'" "feh -.")
                                   ("\\.gif\\'" "feh -.")
				   ))

;; Don't open a new Async Shell Command window
(add-to-list 'display-buffer-alist
  (cons "\\*Async Shell Command\\*.*" (cons #'display-buffer-no-window nil)))

;; Always open a new buffer if default is occupied.
;; seriously why does it ask me this every time? It's so annoying.
(setq async-shell-command-buffer 'new-buffer)

(defun dired-find-file-or-do-async-shell-command ()
  "If there is a default command defined for this file type, run it asynchronously.
If not, open it in Emacs."
  (interactive)
  (let (
	;; get the default for the file type,
	;; putting the string into a list because dired-guess-default throws an error otherwise.
	(default (dired-guess-default (cons (dired-get-filename) '())))
	;; put the file name into a list so dired-shell-stuff-it will accept it
	(file-list (cons (dired-get-filename) '()))
	;; get a filename string(?) for the purpose of testing whether a directory
	(filename (dired-get-filename nil t))
	)
    (if (null default)
	;; if no default found for file, open in Emacs 
	(if (file-directory-p filename)
	    ;; if directory, open in same window
	    (dired-find-file)
	  ;; if not directory, open in right window
	    (progn
	      (windmove-display-right)
	      (dired-find-file)
	      )
	    )	
        ;; if default is found for file, run command asynchronously
      (dired-run-shell-command (dired-shell-stuff-it (concat default " &") file-list nil))
      )
    ) 
)

;; This function is bound to the Return key in dired-mode to replace the default behavior on Return
(define-key dired-mode-map (kbd "<return>") #'dired-find-file-or-do-async-shell-command)

(with-eval-after-load 'ox
  (require 'ox-hugo))

(defun publish-hugo-blog (arg)
  "Commit and push main repo and submodule of static site."
  (interactive "sCommit message:")
  (shell-command (format "publish '%s'" arg)))

(global-set-key (kbd "C-x p") #'publish-hugo-blog)

(require 'tramp)
(setq tramp-debug-buffer t)
(setq tramp-verbose 10)

(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-height 15)

(defun windmove-do-window-select (dir &optional arg window)
  "Modified for better Emacs-i3wm integration.
Move to the window at direction DIR as seen from WINDOW.
DIR, ARG, and WINDOW are handled as by `windmove-find-other-window'.
If no window is at direction DIR, an error is signaled.
If `windmove-create-window' is non-nil, try to create a new window
in direction DIR instead."
  (let ((other-window (windmove-find-other-window dir arg window)))
    (when (and windmove-create-window
               (or (null other-window)
                   (and (window-minibuffer-p other-window)
                        (not (minibuffer-window-active-p other-window)))))
      (setq other-window (split-window window nil dir)))
    (cond ((null other-window)
	   (progn
           ;; (user-error "No window %s from selected window" dir)
	  (interactive)
	  (shell-command (format "i3-msg focus %s" dir))
	  (shell-command (format "i3-msg mode 'default'"))
	  ))
          ((and (window-minibuffer-p other-window)
                (not (minibuffer-window-active-p other-window)))
           (user-error "Minibuffer is inactive"))
          (t
           (select-window other-window)))))
