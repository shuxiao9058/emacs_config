(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/plugins/minors/")
(add-to-list 'load-path "~/.emacs.d/plugins/ecb/")
(add-to-list 'load-path "~/.emacs.d/plugins/session/lisp/")
(add-to-list 'load-path "~/.emacs.d/plugins/git-emacs/")
(add-to-list 'load-path "~/.emacs.d/plugins/color-theme-6.6.0/")

;;------------------------------------------------------------------------------
;; theme
;;------------------------------------------------------------------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/zenburn-emacs")
(load-theme 'zenburn t)
;;------------------------End theme-----------------------

;;------------------------------------------------------------------------------
;; [f11]: toggle-fullscreen
;;------------------------------------------------------------------------------
(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))

(global-set-key [f11] 'toggle-fullscreen)
;;------------------------End toggle-fullscreen-----------------------

;;------------------------------------------------------------------------------
;; tabbar
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/tabbar/")
(require 'tabbar)
(tabbar-mode)
(define-prefix-command 'lwindow-map)
(global-set-key (kbd "<M-up>") 'tabbar-backward-group)
(global-set-key (kbd "<M-down>") 'tabbar-forward-group)
(global-set-key (kbd "<M-left>") 'tabbar-backward)
(global-set-key (kbd "<M-right>") 'tabbar-forward)
;;------------------------End tabbar-----------------------

;;------------------------------------------------------------------------------
;; cedet
;; 参考：http://alexott.net/en/writings/emacs-devenv/EmacsCedet.html
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/cedet-bzr/")
(load-file "~/.emacs.d/plugins/cedet-bzr/cedet-devel-load.el")
(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode
                                  global-semantic-stickyfunc-mode
                                  global-semantic-tag-folding-mode 
                                  global-semantic-decoration-mode
                                  global-semantic-idle-local-symbol-highlight-mode
                                  global-semantic-idle-scheduler-mode
                                  global-semantic-idle-summary-mode  ;;show tag/function information on minibuffer.
                                  global-semantic-idle-completions-mode

                                  ;;
                                  global-semantic-show-unmatched-syntax-mode
                                  global-semantic-show-parser-state-mode
								  ))
(semantic-mode 1)
(global-semantic-highlight-edits-mode (if window-system 1 -1))
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

;; TODO:System header files : (semantic-add-system-include "~/exp/include/boost_1_37" 'c++-mode)

(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))


(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;;;; if you want to enable support for gnu global
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
;; enable ctags for some languages:
;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;; (when (cedet-ectag-version-check)
;;  (semantic-load-enable-primary-exuberent-ctags-support))

;;;; shortcut key
(global-set-key (kbd "C-=")  'senator-fold-tag)
(global-set-key (kbd "C--")  'senator-unfold-tag)
(global-set-key (kbd "M-/") 'semantic-ia-complete-symbol-menu)
(global-set-key [M-f2] 'semantic-analyze-proto-impl-toggle)
(global-set-key [f2] 'semantic-ia-fast-jump)
(global-set-key [S-f2]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))

(defconst cedet-user-include-dirs
  (list "." ".." "../include" "../../include" 
	"../inc" "../../inc" "../common" "../public"
        "../../common" "../../public" ))
;; (require 'semantic-c nil 'noerror) 
;; (require 'semantic-c++  nil 'noerror)
(defun semantic-hook-add-inc ()
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        cedet-user-include-dirs))
(add-hook 'semantic-init-hooks 'semantic-hook-add-inc)
;;------------------------End cedet-----------------------

;;------------------------------------------------------------------------------
;; makefilerunner
;; An easy method of running Makefiles.
;;------------------------------------------------------------------------------
(load-file "~/.emacs.d/plugins/emacs-makefile-runner/makefile-runner.el")
(require 'makefile-runner)  
;;------------------------End autopair-----------------------

;;------------------------------------------------------------------------------
;; sourcepair
;;------------------------------------------------------------------------------
(load-file "~/.emacs.d/plugins/sourcepair.el/sourcepair.el")
(global-set-key [f4] 'sourcepair-load)
(define-key global-map [f1] 'sourcepair-load)
(setq sourcepair-recurse-ignore '("CVS" "bin" "lib" "Obj" "Debug" "Release" "out" ".svn"))
;;------------------------End sourcepair-----------------------

;;------------------------------------------------------------------------------
;; my-base.el
;;------------------------------------------------------------------------------
(load "my-base.el")
;;------------------------End my-base-----------------------

;;------------------------------------------------------------------------------
;; Python
;;------------------------------------------------------------------------------
;;;; python mode: from fgallina/python.el
(require 'python "~/.emacs.d/plugins/minors/python.el")
;;;; ipython
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;;;; Pymacs
(add-to-list 'load-path "~/.emacs.d/plugins/Pymacs")
;; (require 'python "python.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;------------------------End Python-----------------------

;;------------------------------------------------------------------------------
;; color-theme
;;------------------------------------------------------------------------------
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-charcoal-black)))
;;------------------------End color-theme-----------------------

;;------------------------------------------------------------------------------
;; el-get
;;------------------------------------------------------------------------------
(setq el-get-dir "~/.emacs.d/plugins/el-get/")
;;;; el-get script folder
(add-to-list 'load-path "~/.emacs.d/plugins/el-get/el-get/")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync)
(setq el-get-user-package-directory "~/.emacs.d/plugins/el-get/el-get-init-files/")
;;------------------------End el-get-----------------------

;;------------------------------------------------------------------------------
;; yasnippet
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
;;------------------------End yasnippet-----------------------

;;------------------------------------------------------------------------------
;; auto-complete
;; 参考：http://blog.csdn.net/winterttr/article/details/7524336
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/dea-lisp/")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")

(require 'auto-complete-config)
(require 'auto-complete+)
(require 'util)
(require 'ahei-misc)

(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(global-auto-complete-mode)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

(eal-define-keys
 'ac-complete-mode-map
 `(("<return>"   nil)
   ("RET"        nil)
   ("M-j"        ac-complete)))

(load-file "~/.emacs.d/plugins/minors/pos-tip.el")
(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t)   ;default is t
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)
(setq ac-dwim t)
(setq ac-fuzzy-enable t)

(setq ac-auto-show-menu t
        ac-auto-start t
        ac-candidate-limit ac-menu-height
        ac-disable-faces nil)
(set-default 'ac-sources
			 '(ac-source-semantic
			   ac-source-yasnippet
			   ac-source-dictionary
			   ac-source-abbrev
			   ac-source-words-in-buffer
			   ac-source-words-in-same-mode-buffers
			   ac-source-imenu
			   ac-source-files-in-current-dir
			   ac-source-filename))

;;outline
;; (require 'outline-settings)

(require 'compile-settings)

;; autopair
;; Another stab at making braces and pair like in TextMate.
(load-file "~/.emacs.d/plugins/autopair/autopair.el")
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;;;; mode
(defun ac-settings-4-cc ()
  "`auto-complete' settings for `cc-mode'."
     (dolist (command `(c-electric-backspace
                        c-electric-backspace-kill))
       (add-to-list 'ac-trigger-commands-on-completing command)))
(eval-after-load "cc-mode"
  '(progn
	 (ac-settings-4-cc)
	 ;; (require 'smart-operator)
         ;; (smart-operator-mode)
     ))

(defun ac-settings-4-autopair ()
  "`auto-complete' settings for `autopair'."
  (defun ac-trigger-command-p (command)
    "Return non-nil if `this-command' is a trigger command."
    (or
     (and
      (symbolp command)
      (or (memq command ac-trigger-commands)
          (string-match "self-insert-command" (symbol-name command))
          (string-match "electric" (symbol-name command))
          (let* ((autopair-emulation-alist nil)
                 (key (this-single-command-keys))
                 (beyond-autopair (or (key-binding key)
                                      (and (setq key (lookup-key local-function-key-map key))
                                           (key-binding key)))))
            (or
             (memq beyond-autopair ac-trigger-commands)
             (and ac-completing
                  (memq beyond-autopair ac-trigger-commands-on-completing)))))))))
(eval-after-load "autopair"
  '(ac-settings-4-autopair))

(defun ac-settings-4-lisp ()
  "Auto complete settings for lisp mode."
  (setq ac-omni-completion-sources '(("\\<featurep\s+'" ac+-source-elisp-features)
                                     ("\\<require\s+'"  ac+-source-elisp-features)
                                     ("\\<load\s+\""    ac-source-emacs-lisp-features)))
  (ac+-apply-source-elisp-faces)
  (setq ac-sources
        '(ac-source-features
          ac-source-functions
          ac-source-yasnippet
          ac-source-variables
          ac-source-symbols
          ac-source-dictionary
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-files-in-current-dir
          ac-source-filename
          ac-source-words-in-same-mode-buffers)))

(defun ac-settings-4-java ()
  (setq ac-omni-completion-sources (list (cons "\\." '(ac-source-semantic))
                                         (cons "->" '(ac-source-semantic))))
  (setq ac-sources
        '(;;ac-source-semantic
          ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-c ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-dictionary
          ;; ac-source-semantic
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-cpp ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-dictionary
          ;; ac-source-semantic
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-text ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-imenu)))

(defun ac-settings-4-eshell ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename
          ac-source-symbols
          ac-source-imenu)))

(defun ac-settings-4-ruby ()
  (require 'rcodetools-settings)
  (setq ac-omni-completion-sources
        (list (cons "\\." '(ac-source-rcodetools))
              (cons "::" '(ac-source-rcodetools)))))

(defun ac-settings-4-html ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-tcl ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-awk ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(am-add-hooks
 `(lisp-mode-hook emacs-lisp-mode-hook lisp-interaction-mode-hook
                  svn-log-edit-mode-hook change-log-mode-hook)
 'ac-settings-4-lisp)

(apply-args-list-to-fun
 (lambda (hook fun)
   (am-add-hooks hook fun))
 `(('java-mode-hook   'ac-settings-4-java)
   ('c-mode-hook      'ac-settings-4-c)
   ('c++-mode-hook    'ac-settings-4-cpp)
   ('text-mode-hook   'ac-settings-4-text)
   ('eshell-mode-hook 'ac-settings-4-eshell)
   ('ruby-mode-hook   'ac-settings-4-ruby)
   ('html-mode-hook   'ac-settings-4-html)
   ('awk-mode-hook    'ac-settings-4-awk)
   ('tcl-mode-hook    'ac-settings-4-tcl)))
;;------------------------End auto-complete-----------------------

;;------------------------------------------------------------------------------
;; json formator
;;------------------------------------------------------------------------------
(defun json-format ()
  (interactive)
  (save-excursion
	(shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)
	))
;;------------------------End jason formator-----------------------

;;------------------------------------------------------------------------------
;; 实现搜索选中文字
;;------------------------------------------------------------------------------
(defun wcy-define-key-in-transient-mode (global-p key cmd-mark-active  cmd-mark-no-active)
  (funcall (if global-p 'global-set-key 'local-set-key)
           key
           `(lambda ()
              (interactive)
              (if mark-active
                  (call-interactively ',cmd-mark-active)
                (call-interactively ',cmd-mark-no-active)))))

(defun wcy-isearch-forward-on-selection (&optional regexp-p no-recursive-edit)
  (interactive "P\np")
  (let ((text (buffer-substring (point) (mark))))
    (goto-char (min (point) (mark)))
    (setq mark-active nil)
    (isearch-mode t (not (null regexp-p)) nil (not no-recursive-edit))
    (isearch-process-search-string text text)))

(wcy-define-key-in-transient-mode t (kbd "C-s")
                                  'wcy-isearch-forward-on-selection
                                  'isearch-forward)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("7c09d29d8083ecd56b9d5c1a4b887aa2b0dfbe20412b64047686da6711d850bd" default)))
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
)
 (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;------------------------End 实现搜索选中文字-----------------------

;;------------------------------------------------------------------------------
;; git-emacs
;;------------------------------------------------------------------------------
(require 'git-emacs)
;;------------------------git-emacs-----------------------

;;------------------------------------------------------------------------------
;; google-c-style
;;------------------------------------------------------------------------------
(load-file "~/.emacs.d/plugins/google-styleguide/google-c-style.el")  
(add-hook 'c-mode-common-hook 'google-set-c-style)  
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;;------------------------google-c-style-----------------------

;;------------------------------------------------------------------------------
;; auto-header
;;------------------------------------------------------------------------------
;;;; 加载auto-header.el文件,自动添加文件头
(require 'auto-header)

;;;; 设置文件头中的姓名
(setq header-full-name "Allen Shaw")

;;;; 设置邮箱
(setq header-email-address "shuxiao9058#qq.com")

;;;; 设置每次保存时要更新的项目
(setq header-update-on-save
      '(  filename
          modified
          counter
          copyright))
;;;; 设置文件头的显示格式
(setq header-field-list
      '(  
        filename  ;文件名
        copyright ;版权
        version ;版本
        author    ;作者
        created   ;创建时间
        modified_by ;修改者
        modified ;修改时间
        update ;修改次数
        description   ;描述
        ;; blank
        ;;status  ;状态，是否发布
        ;;更新
        ;;blank
        ))
;;------------------------End auto-header-----------------------

;;------------------------------------------------------------------------------
;; session
;;------------------------------------------------------------------------------
(require 'session)
   (add-hook 'after-init-hook 'session-initialize)
;;------------------------End session-----------------------

;;------------------------------------------------------------------------------
;; ECB
;; 部分内容摘自：
;; https://my-emacs-config.googlecode.com/svn-history/r54/trunk/_emacs.d/settings/auto-complete-settings.el
;;------------------------------------------------------------------------------
(require 'ecb)

(add-hook 'ecb-activate-hook
          (lambda ()
            (let ((compwin-buffer (ecb-get-compile-window-buffer)))
              (if (not (and compwin-buffer
                            (ecb-compilation-buffer-p compwin-buffer)))
                  (ecb-toggle-compile-window -1)))))

;;;; 启动ECB，并且不显示每日提示
(setq ecb-auto-activate t
      ecb-tip-of-the-day nil)

;;;; 隐藏和显示ECB窗口
(define-key global-map (kbd "M-0") 'ecb-hide-ecb-windows)
(define-key global-map (kbd "M-9") 'ecb-show-ecb-windows)
 
;;;; 设定ECB窗口比例
(setq ecb-windows-width 0.20)
;;(add-hook 'window-size-change-functions 'ecb-restore-default-window-sizes)

;;;; 使某一ECB窗口最大化
(define-key global-map (kbd "M-1") 'ecb-maximize-window-directories)
(define-key global-map (kbd "M-2") 'ecb-maximize-window-sources)
(define-key global-map (kbd "M-3") 'ecb-maximize-window-methods)
(define-key global-map (kbd "M-4") 'ecb-maximize-window-history)
;;;; 恢复原始窗口布局
(define-key global-map (kbd "M-`") 'ecb-restore-default-window-sizes)
;;------------------------End Ecb-----------------------

;;------------------------------------------------------------------------------
;; xscope
;; 说明：使用前需要进入xscope目录编译安装。
;;  C-c s s 查找函数或变量
;;  C-c s g 查找函数或变量的定义
;;  C-c s c 查找函数被调用的地方
;;  C-c s C 查找函数调用了哪些函数
;;  C-c s p 查找函数上次出现的位置
;;  C-c s n 查找函数下次出现的位置
;;------------------------------------------------------------------------------
(load-file "~/.emacs.d/plugins/cscope-15.8a/contrib/xcscope/xcscope.el")
(require 'xcscope)
(setq cscope-do-not-update-database t)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	    (require 'xcscope)))
;;------------------------End xcscope-----------------------

;;------------------------------------------------------------------------------
;; gdb-UI设置
;;------------------------------------------------------------------------------
(load-library "~/.emacs.d/plugins/gdb-ui/gdb-ui.el")
(load-library "~/.emacs.d/plugins/gdb-ui/gud.el")
(setq gdb-many-windows t)
;;------------------------End gdb-UI-----------------------
