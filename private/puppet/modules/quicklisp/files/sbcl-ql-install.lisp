(load "quicklisp.lisp")
(quicklisp-quickstart:install); :path #P"/home/vagrant/quicklisp")
(ql-util:without-prompting
 (ql:add-to-init-file)
 (ql:quickload "quicklisp-slime-helper"))
(sb-ext:quit)
