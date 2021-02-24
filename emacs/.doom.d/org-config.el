;;; ../Projects-Home/dotfiles/emacs/.doom.d/org-config.el -*- lexical-binding: t; -*-

;;
;; Org-Mode Configuration
;;


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Owncloud/Apps/OrgMode/")

;; Locate all .org files in the OrgMode folders and use them for the agenda
(setq org-agenda-files
      (directory-files-recursively "~/OwnCloud/Apps/OrgMode/" "\.org$"))

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
