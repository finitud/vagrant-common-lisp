(load "/tmp/quicklisp.lisp")
(ql-util:without-prompting
 (quicklisp-quickstart:install)
 (ql:add-to-init-file)
 (ql:quickload "quicklisp-slime-helper"))
