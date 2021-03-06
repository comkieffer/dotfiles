;;; ../Projects-Home/dotfiles/emacs/.doom.d/org-config.el -*- lexical-binding: t; -*-

;;
;; Org-Mode Configuration
;;

(use-package! org-super-agenda :config (org-super-agenda-mode))

;;
;; Set up files and folders
;;

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/OwnCloud/Apps/OrgMode/")

;; Set the default destination for newly created notes (e.g. notes created with
;; org-capture)
(setq org-default-notes-file (expand-file-name "inbox.org" org-directory))

;; Locate all .org files in the OrgMode folders and use them for the agenda
(setq org-agenda-files
      (directory-files-recursively org-directory "\.org$"))

;;
;; Customise Appearance
;;

;; In Org Clock reports, use a european time format (DD/MM/YYYY) instead of US
(setq org-time-stamp-custom-formats '("<%d/%m/%y %a>" . "<%d/%m/%y %a %H:%M>"))

;; use pretty things for the clocktable
(setq org-pretty-entities t)

;; Show actually italicsed text instead of /text/.
(setq org-hide-emphasis-markers t)

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
      (quote ((sequence "TODAY(o)" "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)")
              (sequence "SOMEDAY(h)" "|" "CANCELLED(c)")
              (sequence "Action(a)" "|" "Resolved(r)")
              (sequence "|" "MEETING"))))

;; Configure the font used for each state
(setq org-todo-keyword-faces
      (quote (("TODAY" :foreground "magenta" :weight bold)
              ("TODO" :foreground "orange red" :weight bold)
              ("STARTED" :foreground "royal blue" :weight bold)
              ("WAITING" :foreground "tomato" :weight bold)
              ("DONE" :foreground "sea green" :weight bold)
              ("SOMEDAY" :foreground "dark gray" :weight bold)
              ("CANCELLED" :foreground "light steel blue" :weight bold)
              ("Action" :foreground "orange red" :weight bold)
              ("Resolved" :foreground "sea green" :weight bold)
              ("MEETING" :foreground "sea green" :weight bold))))

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


(setq org-capture-templates
      `(("t" "Todo" entry
         (file+headline org-default-notes-file "Unsorted")
         "* TODO %?\n %i\n ")
        ("m" "Full Meeting" entry
         (file+headline org-default-notes-file "Unsorted")
         (file ,(expand-file-name "templates/meeting.org.tpl" org-directory))
         :empty-lines 1
         :jump-to-captured t)
        ("M" "Simple Meeting (No Agenda)" entry
         (file+headline org-default-notes-file "Unsorted")
         (file ,(expand-file-name "templates/simple-meeting.org.tpl" org-directory))
         :empty-lines 1
         :jump-to-captured t)
        ("g" "Goals this week" entry
         (file ,(expand-file-name "2021-week-in-review.org" org-directory))
         (file ,(expand-file-name "templates/week-in-review.org.tpl" org-directory))
         :empty-lines 1)
        ("c" "Candidate" entry
         (file+headline org-default-notes-file "Unsorted")
         (file ,(expand-file-name "templates/hr-candidate.org.tpl" org-directory))
         :jump-to-captured t)
        ))

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

;; Note: org-super-agenda usage
;;
;; Each group selector creates a group in the agenda containingthe items it
;; matches and consumes those items. Any items it dodn;t match are passed to the
;; next group selector.
;; The :discard selector consumes items without creating an agenda group.
(setq org-agenda-custom-commands
      '(("t" "Today View"
         ((agenda ""
                 ((org-agenda-span 1)
                  (org-agenda-start-day "+0d")
                  (org-deadline-warning-days 0)
                  (org-super-agenda-groups
                   '(
                     (:name "Pending Meeting Actions (For Me)"
                      :and (:todo "Action" :tag "@tch") :order 100)
                     (:discard (:todo "Action"))
                     (:name "Today" :time-grid t :order 20)
                     (:name "Important Tasks" :priority "A" :order 10)
                     (:name "Due Today" :deadline today :order 30)
                     (:name "Someday" :todo "SOMEDAY" :order 45)
                     (:name "Overdue" :deadline past :order 40)
                     (:name "Everything else" :order 50)
                     ))
                  ))
          ))
        ("r" "Review of Actions"
         ((todo "Action"
                 ((org-agenda-span 1)
                  (org-agenda-start-day "+0d")
                  (org-deadline-warning-days 0)
                  (org-super-agenda-groups
                    '(
                      (:name "Overdue Actions" :deadline past :order 100)
                      (:name "Pending Actions" :anything t)
                      )
                    )
                   ))
          ))
        ("c" "Clocked Today"
         ((todo ""
                ((org-super-agenda-groups
                  '((:name "Done today" :and (:regexp "State \"DONE\""
                                              :log t))
                    (:name "Clocked today" :log t))))
                  )))
          ))
