;;     (add-hook 'text-mode-hook
;;       (lambda () (set-input-method "korean-hangul3f")))

;;(defun my-korean3f-setup()
 ;;      "toggle to Korean 3beol-sik final"
 ;;      (if (equal current-language-environment "Korean")
 ;;          (setq default-input-method "korean-hangul3f")))
;;     (add-hook 'set-language-environment-hook 'my-korean3f-setup)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq default-korean-keyboard "3f")

;;(with-eval-after-load "language/korea-util"
;;(defun toggle-korean-input-method ()
;;  "Turn on or off a Korean text input method for the current buffer."
;;  (interactive)
;;  (if current-input-method
;;      (deactivate-input-method)
;;    (activate-input-method
;;     (concat "korean-hangul3f" default-korean-keyboard)))))

;;(defun togggle-to-hangul3f()
;;	"toggle to Korean 3beol-sik final"
;;	(if (equal default-input-method "korean-hangul")
;;		(setq default-input-method "korean-hangul3f")))
;;(add-hook 'set-toggle-korean-input-method-hook 'toggle-to-hangul3f)

;;(custom-set-variables
 ;;'(default-input-method "korean-hangul3f"))


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

(setq default-input-method "korean-hangul3f")

;;(set-input-method "korean-hangul3f")

(require 'mu4e)

(setq mu4e-change-filenames-when-moving t)

;; make text flow in mu4e composition
(setq mu4e-compose-format-flowed t)

(require 'gnus-dired)
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

;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(org-agenda-files
 ;;  (quote
  ;;  ("~/Documents/research/philosophy/2020-readingroom-notes.org" "~/Documents/research/cbd-yt/notes-2020cbdyt.org" "~/Documents/records/journal.org"))))

(set-face-attribute 'default nil :family "DejaVu Sans Mono")

(set-face-attribute 'default nil :height 150)

;; (set-face-attribute 'fringe nil :background nil)

(set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding"))

(set-face-attribute 'variable-pitch nil :family "DejaVu Sans Condensed")

(set-face-attribute 'variable-pitch nil :height 150)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c m") 'mu4e)
(global-set-key (kbd "C-c t") '(lambda () (interactive) (ansi-term "/bin/bash")))
(global-set-key (kbd "C-c w") 'count-words)

(setq inhibit-splash-screen t)
(ansi-term "/usr/bin/bash")
(org-agenda-list)
(delete-other-windows)

;;(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-deep-blue)))

(menu-bar-mode -1)
(tool-bar-mode -1)

  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)

;; (require 'undo-fu)
;; (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
;; (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo)

(setq evil-want-integration t)
(setq evil-want-keybinding nil)

(defun lj-org-mode-hook ()
  (evil-org-mode +1)
  (olivetti-mode +1)
  ;; (variable-pitch-mode +1)
)

(add-to-list 'load-path "~/.emacs.d/lisp/evil-org-mode")
(require 'evil-org)
;; (add-hook 'org-mode-hook 'evil-org-mode)
(add-hook 'org-mode-hook #'lj-org-mode-hook)
(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)
;; (add-hook 'org-mode-hook (lambda () (variable-pitch-mode t))

(require 'evil)
(evil-mode 1)

(when (require 'evil-collection nil t)
  (evil-collection-init))

;; (add-hook 'evil-org-mode-hook 'olivetti-mode)

;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

(setq default-directory "~/")
(start-process "picom" nil "picom")

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(start-process "wallpapers" nil "feh" "--bg-fill" "-z" "/home/lj/Pictures/Wallpaper/gris/" "--bg-fill" "-z" "/home/lj/Pictures/Wallpaper/gris/vertical")

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("/home/lj/Documents/records/journal.org" "/home/lj/Documents/writing/soseono/draft.org")))
 '(package-selected-packages
   (quote
    (undo-fu pdf-tools dired-toggle-sudo emms olivetti evil-collection magit evil))))


;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(fringe ((t (:background "#102e4e")))))

(set-face-attribute 'fringe t :background "#102e4e")

(defun er-sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-c o") #'er-sudo-edit)
