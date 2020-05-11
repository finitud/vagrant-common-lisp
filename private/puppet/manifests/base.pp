exec { 'initial update':
  command => '/usr/bin/apt-get update',
}

package { ['emacs25', 'emacs25-el', 'emacs25-common-non-dfsg',
           'curl',
           'git-core',
           'sbcl', 'sbcl-doc', 'sbcl-source',
           'clisp', 'clisp-doc','clisp-dev', 'gdb',
           'tmux',
           'vim-nox',
           ]:
  ensure => present,
  require => Exec['initial update'],
}

exec { 'download quicklisp':
  user => 'vagrant',
  command => '/usr/bin/curl http://beta.quicklisp.org/quicklisp.lisp -o /home/vagrant/quicklisp.lisp',
  creates => '/home/vagrant/quicklisp.lisp',
  require => Package['curl'],
}

# The original version of this script downloaded quicklisp.lisp
# as user:group root:root, which is undesirable. This fixes that
# issue in an already-provisioned VM.
exec { 'fix quicklisp permissions':
  command => '/bin/chown vagrant quicklisp.lisp',
  require => Exec['download quicklisp'],
}

file { 'sbcl-ql-install.lisp':
  path => '/home/vagrant/sbcl-ql-install.lisp',
  ensure => present,
  owner => 'vagrant',
  source => 'puppet:///modules/quicklisp/sbcl-ql-install.lisp',
}

file { 'emacs-dir':
  path => '/home/vagrant/.emacs.d',
  ensure => 'directory',
  owner => 'vagrant',
  mode => '755',
}

file { 'dot-emacs':
  path => '/home/vagrant/.emacs',
  ensure => present,
  owner => 'vagrant',
  source => 'puppet:///modules/quicklisp/dot-emacs',
}

file { 'load-slime.el':
  path => '/home/vagrant/.emacs.d/load-slime.el',
  ensure => present,
  owner => 'vagrant',
  source => 'puppet:///modules/quicklisp/load-slime.el',
  require => File['emacs-dir'],
}

exec { 'install quicklisp':
  cwd => '/home/vagrant',
  creates => '/home/vagrant/quicklisp/setup.lisp',
  environment => 'HOME=/home/vagrant',
  user => 'vagrant',
  command => '/usr/bin/sbcl --load sbcl-ql-install.lisp',
  require => [ File['sbcl-ql-install.lisp'],
               File['emacs-dir'],
               Package['sbcl'],
               Exec['download quicklisp'],
	       ],
}

file { 'dot-profile':
  path => '/home/vagrant/.profile',
  ensure => present,
  owner => 'vagrant',
  source => 'puppet:///modules/tmux/dot-profile',
}

file { 'dot-tmux':
  path => '/home/vagrant/.tmux',
  ensure => present,
  owner => 'vagrant',
  source => 'puppet:///modules/tmux/dot-tmux.conf',
}

file { 'dot-vim':
  path => '/home/vagrant/.vim',
  ensure => present,
  owner => vagrant,
  source => 'puppet:///modules/slimv/dot-vim',
  recurse => true,
}

file { 'dot-vimrc':
  path => '/home/vagrant/.vimrc',
  ensure => present,
  owner => vagrant,
  source => 'puppet:///modules/slimv/dot-vimrc',
}

exec { 'download vim-pathogen':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle',
  command => '/usr/bin/git clone https://github.com/tpope/vim-pathogen.git',
  creates => '/home/vagrant/.vim/bundle/vim-pathogen',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Package['vim-nox'],
	       ],
}

exec { 'install vim-pathogen':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle/vim-pathogen',
  command => '/usr/bin/git checkout v2.3',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download vim-pathogen'],
               Package['vim-nox'],
	       ],
}


exec { 'download vim-sensible':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle',
  command => '/usr/bin/git clone https://github.com/tpope/vim-sensible.git',
  creates => '/home/vagrant/.vim/bundle/vim-sensible',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download vim-pathogen'],
               Package['vim-nox'],
	       ],
}

exec { 'install vim-sensible':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle/vim-sensible',
  command => '/usr/bin/git checkout v1.1',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download vim-sensible'],
               Package['vim-nox'],
	       ],
}

exec { 'download syntastic':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle',
  command => '/usr/bin/git clone https://github.com/scrooloose/syntastic.git',
  creates => '/home/vagrant/.vim/bundle/syntastic',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download vim-pathogen'],
               Package['vim-nox'],
	       ],
}

exec { 'install syntastic':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle/syntastic',
  command => '/usr/bin/git checkout 3.10.0',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download syntastic'],
               Package['vim-nox'],
	       ],
}


exec { 'download slimv':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle',
  command => '/usr/bin/git clone https://github.com/kovisoft/slimv.git',
  creates => '/home/vagrant/.vim/bundle/slimv',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download vim-pathogen'],
               Package['vim-nox'],
	       ],
}

exec { 'install slimv':
  user => 'vagrant',
  cwd => '/home/vagrant/.vim/bundle/slimv',
  command => '/usr/bin/git checkout c832d79c2fdeb094cae109e45c1c41d3d520af2a',
  require => [ File['dot-vim'],
               File['dot-vimrc'],
               Exec['download slimv'],
               Package['vim-nox'],
               Package['tmux'],
	       ],
}

