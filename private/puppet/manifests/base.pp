exec { 'initial update': 
  command => '/usr/bin/apt-get update',
}

package { ['curl', 'python-software-properties']:
  ensure => present,
  require => Exec['initial update'],
}

exec { 'add emacs repository':
  command => '/usr/bin/add-apt-repository ppa:cassou/emacs -y',
  require => Package['python-software-properties'],
}

exec { 'second update':
  command => '/usr/bin/apt-get update',
  require => Exec['add emacs repository'],
}

package { ['emacs24', 'emacs24-el', 'emacs24-common-non-dfsg',
           'git-core',
           'sbcl', 'sbcl-doc', 'sbcl-source',
           ]:
  ensure => present,
  require => Exec['second update'],
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
               Exec['download quicklisp'],  ],
}
