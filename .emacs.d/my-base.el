;;------------------------------------------------------------------------------
;; 一些快捷键
;;------------------------------------------------------------------------------
;;;; 显示帮助命令
(global-set-key [f1] 'manual-entry)
(global-set-key [C-f1] 'info)

;;;; gdb调试
(global-set-key [f6] 'gdb)

;;;; F12调到函数定义
(global-set-key [f12] 'semantic-ia-fast-jump)

;;;; 其他
(global-set-key [f3] 'grep-find)
(global-set-key [f7] 'smart-compile)
;;------------------------End 一些快捷键-----------------------

;;------------------------------------------------------------------------------
;; ido-mode
;; By super-charging Emacs's completion engine and improving the speed at 
;; which you open files and buffers.
;; See here: http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/
;;------------------------------------------------------------------------------
;; (setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)
(setq ido-file-extensions-order '(".txt" ".py" ".h" ".el" ".cpp" ".h" ".cc" ".html"))
;;------------------------End ido-----------------------

;;;; 启用ibuffer支持，增强*buffer*  
(require 'ibuffer)  
(global-set-key (kbd "C-x C-b") 'ibuffer)  

;;;; 默认进入text-mode，而不是没有什么功能的fundamental-mode  
(setq-default major-mode 'text-mode)  
(add-hook 'text-mode-hook 'turn-on-auto-fill) 

;;;; 显示行号line number
(load-file "~/.emacs.d/plugins/minors/linum+.el")
(require 'linum+)
(global-linum-mode)  

;;;; For Linux
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

;;;; 设定语言环境为utf-8  
(setq current-language-environment "utf-8")  
;;;; (setq default-input-method "chinese-py")  
(setq locale-coding-system 'utf-8)  
(setq set-terminal-coding-system 'utf-8)  
(setq set-keyboard-coding-system 'utf-8)  
(setq set-selection-coding-system 'utf-8)  
(setq prefer-coding-system 'utf-8)

(require 'info-look)
(info-lookup-add-help
 :mode 'python-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec
 '(("(python)Index" nil "")))

;;------------------------------------------------------------------------------
;; 缓冲区
;;------------------------------------------------------------------------------
;;;; 设定行距
(setq default-line-spaceing 4)
;;;; 页宽
(setq-default fill-column 80)
;;;; 缺省模式 text-mode
(setq default-major-mode 'text-mode)
;;;; 设置一个很大的kill ring
(setq kill-ring-max 300)
(setq require-final-newline t)
;;;; 开启语法高亮
(setq global-font-lock-mode t)
;;;;高亮显示区域选择
(setq transient-mark-mode t)
;;;; 页面平滑滚动
;;;; scroll-margin 3靠近屏幕边沿3行开始滚动，正好可以看到上下文
(setq scroll-margin 3 scroll-consrvatively 10000)
;;;; 高亮显示成对括号
(setq show-paren-mode t)
(setq show-paren-style 'parentheses)	
;;;; 光标靠近鼠标指针时，让鼠标指针自动离开
(mouse-avoidance-mode 'animate)
;;;; 粘贴于光标处,而不是鼠标指针处
(setq mouse-yank-at-point t)
;;------------------------End 缓冲区-----------------------

;;------------------------------------------------------------------------------
;; 回显区
;;------------------------------------------------------------------------------
;;;; 锁定行高
(setq resize-mini-windows nil)
;;;; 递归minibuffer
(setq enable-recursive-minibuffers t)
;;;; 当使用M-x COMMAND后，过1秒显示该COMMAND绑定的键
(setq suggest-key-bindings-1)   ;;默认？
;;------------------------End 回显区-----------------------

;;------------------------------------------------------------------------------
;; 编辑器的设定
;;------------------------------------------------------------------------------
;;;; 不产生备份文件
;; (setq make-backup-files nil)
;;;; 不生成临时文件
;; (setq-default make-backup-files nil)
;;;; 只渲染当前屏幕语法高亮，加快显示速度
(setq lazy-lock-defer-on-scrolling t)
;;(setq font-lock-support-mode 'lazy-lock-mode)
(setq font-lock-maximum-decoration t)

;;;; 显示80列就换行
(add-hook 'message-mode-hook (lambda()
                               (setq default-fill-column 80)
                               (turn-on-auto-fill)))

;;;; 设置tab宽度为4
(setq-default indent-tabs-mode nil)
(setq tab-width 4 c-basic-offset 4)
(setq indent-line-function 'insert-tab)

;;;; 设置光标为线条状
(setq blink-cursor-mode t)
(setq-default cursor-type 'bar)

;;;; 设置是否显示光标所在列号
(setq column-number-mode t)
(setq line-number-mode t)

;;;; 以y/n代表yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;;; 高亮当前行
(require 'hl-line)
(setq global-hl-line-mode t)
;;------------------------End 编辑器的设定-----------------------

;;------------------------------------------------------------------------------
;; 外观设置
;;------------------------------------------------------------------------------
;;;; 去掉滚动条
;; (set-scroll-bar-mode nil)
;;;; 滚动条在右侧
(setq set-scroll-bar-mode 'right)

;;;; 禁用工具栏
(setq tool-bar-mode nil)

;;;; 禁用菜单栏
;; (setq menu-bar-mode nil)

;;;; 在标题栏显示buffer的名字（默认不显示）
;;;; %f：缓冲区完整路径 
;;;; %p：页面百分数
;;;; %l：行号
(setq frame-title-format "%f@GNU Emacs")

;;;; 状态栏：显示时间
(display-time)
(setq display-time-mode t)
(setq display-time-24hr-format t)
;;;; 时间显示包括日期和具体时间
(setq display-time-day-and-date t)
;;;; 时间栏旁边启用邮件设置
;;(setq display-time-use-mail-icon t)
;;;; 时间的变化频率，单位多少来着？
;;(setq display-time-interval 10)

;;;; 禁用启动信息  
(setq inhibit-startup-message t) 

;;;; 让Emacs可以直接打开和显示图片
(setq auto-image-file-mode t)

(setq cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(setq transient-mark-mode t) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;;;; 在行首C-k时，同时删除该行
(setq-default kill-whole-line t)

;;;; 使用X剪贴板
(setq x-select-enable-clipboard t)
;;;; 设定剪贴板的内容格式 适应Firefox
(set-clipboard-coding-system 'ctext)

;;;; 使用鼠标中键可以粘贴
(setq mouse-yank-at-point t)

;;;; 自动的在文件末增加一新行
(setq require-final-newline t)

;;;; Non-nil if Transient-Mark mode is enabled.
(setq-default transient-mark-mode t)

;;;; 当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)

;;;; 当浏览man page时，直接跳转到man buffer
(setq Man-notify-method 'pushy)

;;;; 设置时间戳，标识出最后一次保存文件的时间。
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
(setq time-stamp-format "%:y-%02m-%02d %3a %02H:%02M:%02S chenyang")
;;------------------------End 编辑器的设定-----------------------

;;;; 设置默认工作目录
;; (setq default-directory "~/")

;;;; 关闭烦人的出错时的提示声
(setq visable-bell t)

;;;; 设置Emacs窗口启动大小
;; (setq default-frame-alist  
;;      '((height . 32) (width . 50) (menu-bar-lines . 20) (tool-bar-lines . 0)))  

