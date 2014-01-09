(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/plugins/minors/")
(add-to-list 'load-path "~/.emacs.d/plugins/ecb/")
(add-to-list 'load-path "~/.emacs.d/plugins/session/lisp/")
(add-to-list 'load-path "~/.emacs.d/plugins/git-emacs/")
(add-to-list 'load-path "~/.emacs.d/plugins/markdown-mode/")

;;------------------------------------------------------------------------------
;; theme
;;------------------------------------------------------------------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/zenburn-emacs")
(load-theme 'zenburn t)
;;------------------------End theme-----------------------

;;------------------------------------------------------------------------------
;; [f11]: toggle-fullscreen
;;------------------------------------------------------------------------------
(defvar my-fullscreen-p t "Check if fullscreen is on or off")

(defun my-non-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND restore #xf120
	  (w32-send-sys-command 61728)
	(progn (set-frame-parameter nil 'width 82)
		   (set-frame-parameter nil 'fullscreen 'fullheight))))

(defun my-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND maximaze #xf030
	  (w32-send-sys-command 61488)
	(set-frame-parameter nil 'fullscreen 'fullboth)))

(defun my-toggle-fullscreen ()
  (interactive)
  (setq my-fullscreen-p (not my-fullscreen-p))
  (if my-fullscreen-p
	  (my-non-fullscreen)
	(my-fullscreen)))
(global-set-key [f11] 'my-toggle-fullscreen)
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

(require 'popup)
;;;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

(setq semantic-default-submodes '(
                                  global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode
                                  global-semantic-stickyfunc-mode
                                  global-semantic-tag-folding-mode 
                                  global-semantic-decoration-mode
                                  global-semantic-idle-local-symbol-highlight-mode
                                  global-semantic-idle-scheduler-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-idle-completions-mode
                                  global-semantic-highlight-func-mode
                                  global-semantic-show-unmatched-syntax-mode
                                  global-semantic-show-parser-state-mode
								  ))
(semantic-mode 1)
(global-semantic-highlight-edits-mode (if window-system 1 -1))
(require 'semantic/ia)
(require 'semantic/bovine/gcc)

;; (semantic-add-system-include "~/exp/include/boost_1_37" 'c++-mode)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;;;; if you want to enable support for gnu global
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;;;; enable ctags for some languages:
;;;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;;(when (cedet-ectag-version-check)
;;  (semantic-load-enable-primary-exuberent-ctags-support))

;;;; use projects
(global-ede-mode t)

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

;; (setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst cedet-win32-include-dirs
  (list "C:/MinGW/include"
        "C:/MinGW/include/c++/3.4.5"
        "C:/MinGW/include/c++/3.4.5/mingw32"
        "C:/MinGW/include/c++/3.4.5/backward"
        "C:/MinGW/lib/gcc/mingw32/3.4.5/include"
        "C:/Program Files (x86)/CodeBlocks/MinGW/include"
        "C:/Program Files (x86)/CodeBlocks/MinGW/include/sys"
        "C:/Program Files (x86)/CodeBlocks/MinGW/lib/gcc/mingw32/4.7.1/include/c++"
        "C:/Program Files (x86)/CodeBlocks/MinGW/lib/gcc/mingw32/4.7.1/include"
        "C:/Program Files (x86)/CodeBlocks/MinGW/lib/gcc/mingw32/4.7.1/include/ssp"))
(defconst cedet-gnu/linux-include-dirs
  (list "/usr/include"
        "/usr/include/c++/4.8.1"
        "/usr/include/c++/4.8.1/tr1"
        "/usr/include/c++/4.8.1/tr2"
        "/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.1/include"))
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
  (when (eq system-type 'gnu/linux)
    (setq include-dirs (append include-dirs cedet-gnu/linux-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
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
;; php-mode
;;------------------------------------------------------------------------------
;;;; 加载php-mode
(load-file "~/.emacs.d/plugins/php-mode/php-mode.el")
(require 'php-mode)
;;;; 根据文件扩展名自动php-mode
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
;;;; 开发项目时，php源文件使用其他扩展名
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))
;;------------------------End php-mode-----------------------

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
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")

(require 'auto-complete-config)

(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(global-auto-complete-mode)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;; (load-file "~/.emacs.d/plugins/minors/pos-tip.el")
(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t)   ;default is t
(setq ac-use-quick-help t)
(setq ac-quick-help-delay 1.0)
(setq ac-dwim t)

(load-file "~/.emacs.d/plugins/minors/fuzzy.el")
(require 'fuzzy)
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

;; autopair
;; Another stab at making braces and pair like in TextMate.
(load-file "~/.emacs.d/plugins/autopair/autopair.el")
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers
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
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
 '(session-use-package t nil (session)))
 
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
;; markdown-mode
;;------------------------------------------------------------------------------
(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(defun markdown-custom ()
  "markdown-mode-hook"
  (setq markdown-command "pandoc"))
(add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))
;;------------------------markdown-mode-----------------------

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

;;------------------------------------------------------------------------------
;; my-base.el
;;------------------------------------------------------------------------------
(load "my-base.el")
;;------------------------End my-base-----------------------
