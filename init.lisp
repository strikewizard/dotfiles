(run-shell-command "xsetroot -cursor_name left_cursor")
(run-shell-command "xset r rate 250 35")
(run-shell-command "picom --experimental-backends")

(setf *window-format* "%m%n%s%c")
(setf *screen-mode-line-format* (list "[^B%n^b] %W^>"
				      '(:EVAL (bat))
				      " %d"))
(setf *time-modeline-string* "%a %b %e %k:%M")
(setf *mode-line-timeout* 2)
(enable-mode-line (current-screen) (current-head) t)
(setf *mouse-focus-policy* :click)

(gnew "Primary")
(gnewbg "Secondary")
(gnewbg-float "Tertiary")
(gnewbg "Quaternary")
(gnewbg-float "Quinary")

(set-prefix-key (kbd "M-."))
(define-key *root-map* (kbd "V") "hsplit")
(define-key *top-map* (kbd "C-M-t") "exec st")
(define-key *top-map* (kbd "C-M-c") "exec chromium")
(define-key *top-map* (kbd "C-M-e") "exec emacs")
(define-key *top-map* (kbd "C-M-d") "exec thunar")
(define-key *top-map* (kbd "M-Q") "exec sudo poweroff")
(define-key *top-map* (kbd "M-1") "gselect 2")
(define-key *top-map* (kbd "M-!") "gmove 2")
(define-key *top-map* (kbd "M-2") "gselect 3")
(define-key *top-map* (kbd "M-@") "gmove 3")
(define-key *top-map* (kbd "M-3") "gselect 4")
(define-key *top-map* (kbd "M-#") "gmove 4")
(define-key *top-map* (kbd "M-0") "gselect 1")
(define-key *top-map* (kbd "M-]") "gmove 1")
(define-key *top-map* (kbd "M-p") "exec dmenu_run")
(define-key *top-map* (kbd "M-n") "note")
(define-key *top-map* (kbd "M-w") "windowlist")
(define-key *top-map* (kbd "s-x") "eval")
(define-key *top-map* (kbd "s-z") "colon")
(define-key *top-map* (kbd "M-TAB") "next")
(define-key *top-map* (kbd "M-S-RET") "exec st")
(define-key *top-map* (kbd "M-C") "kill-window")
(define-key *top-map* (kbd "Print") "exec xfce4-screenshooter")
(define-key *top-map* (kbd "S-XF86MonBrightnessDown") "exec xbacklight -2%")
(define-key *top-map* (kbd "S-XF86MonBrightnessUp") "exec xbacklight +2%")
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec xbacklight -5%")
(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec xbacklight +5%")


(defun mpv (str)
  (run-shell-command (concatenate 'string "mpv " str)))

(defun img (str)
  (run-shell-command (concatenate 'string "qimgv " str)))

(defcommand yt (str)
  ((:string "yt: "))
  (mpv str)
  (message "Opening mpv"))

(defcommand sd () ()
  (run-shell-command "sudo poweroff"))

(defun bat ()
  (let ((bat% (parse-integer (run-shell-command "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -Eo '[0-9]{1,}'" t)))
	(bat$ (batstat)))
  (if (eq 100 bat%)
      (format nil "~a *" bat$)
      (if (< bat% 30)
	  (format nil "~a ^1LOW^* ^B~a !^b" bat$ bat%)
	  (format nil "~a ~a %" bat$ bat%)))))

(defun batch ()
  (run-shell-command "upower -i $(upower -e | grep BAT) | grep state | grep -w charging" t))

(defun batdisch ()
  (run-shell-command "upower -i $(upower -e | grep BAT) | grep state | grep -w discharging" t))

(defun batfc ()
  (run-shell-command "upower -i $(upower -e | grep BAT) | grep state | grep -w fully-charged" t))

(defun batstat ()
  (if (> (length (batch)) 0)
      "^2CHG^*"
      (if (> (length (batdisch)) 0)
	  "^3DISCHG^*"
	  (if (> (length (batfc)) 0)
	      "FUL"
	      "^1ERR^*"))))

;
