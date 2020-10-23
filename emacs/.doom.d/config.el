;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Thibaud Chupin"
      user-mail-address "thibaud.chupin@spaceapplications.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Owncloud/Documents/OrgMode/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default
 delete-by-moving-to-trash t  ;; Delete files by moving to trash
 tab-width 4)

(setq evil-want-fine-undo t  ;; By default, all changes in insert mode are one
                             ;; big blob. Be more granular
      auto-save-default t)   ;; Enable autosave

;;
;; Org-Mode Configuration
;;

;; Locate all .org files in the OrgMode folders and use them for the agenda
(setq org-agenda-files
      (directory-files-recursively "~/Documents/OwnCloud/Documents/OrgMode/" "\.org$"))

;; In Org Clock reports, use a european time format (DD/MM/YYYY) instead of US
(setq org-time-stamp-custom-formats '("<%d/%m/%y %a>" . "<%d/%m/%y %a %H:%M>"))

;; use pretty things for the clocktable
(setq org-pretty-entities t)

;; Insert an empty line after new headings but not after plain list items
(setq org-blank-before-new-entry
      '((heading . t) (plain-list-item . nil)))

;;
;; Org-Mode - Time and Task Management
;;

;; Save clock history across Emacs sessions. This way, when re-opening emacs,
;; clocking out will close the active clock even it was started in another
;; session.
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)

;; Store a timestamp each time a task is marked as DONE.
(setq org-log-done 'time)

;; Define the list of Keywords
;; - A state is initailly TODO.
;; - When work starts it becomes STARTED.
;; - If the task cannot be completed due to an external dependency, it should be WAITING
;; - Once finished a task is DONE
;;
;; Some tasks may be CANCELLED or labelled as HOLD if priorities change.
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "HOLD(h)" "CANCELLED(c)")
              (sequence "|" "MEETING" "PHONE"))))

;; Configure the font used for each state
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "orange red" :weight bold)
              ("STARTED" :foreground "royal blue" :weight bold)
              ("DONE" :foreground "sea green" :weight bold)
              ("WAITING" :foreground "tomato" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "light steel blue" :weight bold)
              ("PHONE" :foreground "maroon" :weight bold)
              ("MEETING" :foreground "maroon" :weight bold))))

;; Change a task state into any other by pressing the apprpriate key from the
;; fast-todo selection key menu. Press C-c C-t KEY to open the menu and the KEY
;; defined in the org-todo-keywords command
(setq org-use-fast-todo-selection t)

;; Automatically mark a task as DONE when all of its children are DONE.
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;;
;; Org-Mode Refile Configuration
;;

;; Tell org where to find the possible targets for REFILE
;; Press C-c C-w to list them (SPC-m-R with Spacemacs)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-outline-path-complete-in-steps nil)

;; Show full paths for refiling
(setq org-refile-use-outline-path t)

;; When refiling, place items at the top (first)
(setq org-reverse-note-order t)

;;
;; Org-Export Configuration
;;

; Make org-export save files to `exported-org-files' instead of the CWD.
(defun org-export-output-file-name-modified (orig-fun extension &optional subtreep pub-dir)
  (unless pub-dir
    (setq pub-dir "exported-org-files")
    (unless (file-directory-p pub-dir)
      (make-directory pub-dir)))
  (apply orig-fun extension subtreep pub-dir nil))
(advice-add 'org-export-output-file-name :around #'org-export-output-file-name-modified)

;;
;; Org-Mode Capture Templates
;;

;; Capture Templates
;; (see [[Capture Templates][https://orgmode.org/manual/Template-elements.html#Template-elements]] for more information on capture templates)
;; (see [[Template Expansion][https://orgmode.org/manual/Template-expansion.html#Template-expansion]] for more information on % specifiers)
;;
;; ** Todo Template
;;
;; Add a new tasks under the Tasks heading of the Tasks file.
;;
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Documents/OwnCloud/Documents/OrgMode/todo.org" "Tasks")
         "* TODO %?\n %i\n ")))

;;
;; Org-Mode agenda configuration
;;

(defun tch-org-skip-subtree-if-priority (priority)
"Skip an agenda subtree if it has a priority of PRIORITY.

PRIORITY may be one of the characters ?A, ?B, or ?C."
(let ((subtree-end (save-excursion (org-end-of-subtree t)))
      (pri-value (* 1000 (- org-lowest-priority priority)))
      (pri-current (org-get-priority (thing-at-point 'line t))))
  (if (= pri-value pri-current)
      subtree-end
    nil)))

(setq org-agenda-custom-commands
      '(("c" "Today's overview"
         ;; Create a first block containing actionable high priority tasks
         ;; This means tasks that are not done and not held/waiting
         ((tags "PRIORITY=\"A\"&DEADLINE<=\"<+7d>\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "STARTED")))
                 (org-agenda-overriding-header "High Priority Active Tasks:")
                 (org-agenda-sorting-strategy '(priority-down todo-state-down deadline-down))))
          ;; The next block shows the week agenda.
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-deadline-warning-days 0))
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done)))
          ;; Show blocked tasks
          (todo "HOLD|WAITING"
                ((org-agenda-overriding-header "Held and Waiting Tasks")
                 (org-agenda-sorting-strategy '(priority-down todo-state-down deadline-down))))
          ;; Finally we display the global todo list
          (alltodo ""
                   ((org-agenda-skip-function
                     '(or (tch-org-skip-subtree-if-priority ?A)
                          (org-agenda-skip-if nil '(scheduled deadline))))
                    (org-agenda-overriding-header "Normal Priority Tasks:")))))))
