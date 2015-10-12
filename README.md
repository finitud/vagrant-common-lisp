Common Lisp Vagrantfile
======

This is a minimal environment to set up a vagrant box for Common Lisp development.
It includes the following features:
* 32-bit Ubuntu 14.04 Trusty Tahir based
* SBCL
* Emacs 24
* Quicklisp
* Port 80 forwarded to localhost:8000

To set up, clone the repository and run:

     vagrant up

The new box can be accessed by typing:

     vagrant ssh

The contents of the current directory can be accessed from the virtual machine at `/vagrant`,
so you can clone the repository to a new folder and copy your projects there (cleaner) or
just throw the files into your project's main directory (less clean).

This project is licensed under the MIT Licence. See LICENCE.txt for the full text.
