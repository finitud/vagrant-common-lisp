#! /bin/bash

# # Only let the user 'vagrant' run the script
# # We don't want to break anything outside the vagrant box
# if [ $USER != 'vagrant' ]; then
#     echo "This script is to be run in vagrant"
#     exit 1
# fi

# Get apt up to date and install some basic stuff
sudo apt-get update
sudo apt-get install -y python-software-properties curl
sudo add-apt-repository ppa:cassou/emacs -y
sudo apt-get update

# Install the development environment
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg
sudo apt-get install -y git-core
sudo apt-get install -y sbcl sbcl-doc sbcl-source

# Install and configure Quicklisp
curl -O http://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp <<EOF
(quicklisp-quickstart:install)
(ql:add-to-init-file)
(ql:quickload "quicklisp-slime-helper")

EOF

# Configure dot-emacs file to load Quicklisp slime helper
echo "(load (expand-file-name \"~/quicklisp/slime-helper.el\"))" >> ~/.emacs
echo "(setq inferior-lisp-program \"/usr/bin/sbcl\")" >> ~/.emacs

