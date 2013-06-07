((auto-complete status "installed" recipe
                (:name auto-complete :website "http://cx4a.org/software/auto-complete/" :description "The most intelligent auto-completion extension." :type github :pkgname "m2ym/auto-complete" :depends
                       (popup fuzzy)))
 (auto-complete+ status "removed" recipe nil)
 (auto-complete-clang status "installed" recipe
                      (:name auto-complete-clang :website "https://github.com/brianjcj/auto-complete-clang" :description "Auto-complete sources for Clang. Combine the power of AC, Clang and Yasnippet." :type github :pkgname "brianjcj/auto-complete-clang" :depends auto-complete))
 (auto-complete-emacs-lisp status "installed" recipe
                           (:name auto-complete-emacs-lisp :description "Auto-complete sources for emacs lisp" :type http :url "http://www.cx4a.org/pub/auto-complete-emacs-lisp.el" :depends auto-complete))
 (auto-complete-extension status "installed" recipe
                          (:name auto-complete-extension :type emacswiki :description "Some extension for auto-complete-mode" :depends auto-complete))
 (auto-complete-yasnippet status "removed" recipe nil)
 (bindings+ status "installed" recipe
            (:name bindings+ :auto-generated t :type emacswiki :description "Enhancements to standard library `bindings.el'." :website "https://raw.github.com/emacsmirror/emacswiki.org/master/bindings+.el"))
 (cedet status "removed" recipe nil)
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :features el-get :info "." :load "el-get.el"))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/m2ym/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "m2ym/fuzzy-el"))
 (ido-hacks status "removed" recipe nil)
 (popup status "installed" recipe
        (:name popup :website "https://github.com/m2ym/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "m2ym/popup-el"))
 (pymacs status "removed" recipe nil)
 (rope status "installed" recipe
       (:name rope :description "A python refactoring library" :post-init
              (el-get-envpath-prepend "PYTHONPATH" default-directory)
              :type hg :url "http://bitbucket.org/agr/rope"))
 (yasnippet status "removed" recipe nil))
