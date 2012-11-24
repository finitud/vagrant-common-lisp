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
  command => '/usr/bin/curl http://beta.quicklisp.org/quicklisp.lisp -o /home/vagrant/quicklisp.lisp',
  require => Package['curl'],
}

file { 'sbcl-ql-install.lisp':
  path => '/home/vagrant/sbcl-ql-install.lisp',
  ensure => present,
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
  source => 'puppet:///modules/quicklisp/dot-emacs',
}

file { 'load-slime.el':
  path => '/home/vagrant/.emacs.d/load-slime.el',
  ensure => present,
  source => 'puppet:///modules/quicklisp/load-slime.el',
  require => File['emacs-dir'],
}

file { 'sbcl-ql-setup.sh' :
  path => '/home/vagrant/sbcl-ql-setup.sh',
  ensure => present,
  owner => 'vagrant',
  mode => '750',
  source => 'puppet:///modules/quicklisp/sbcl-ql-setup.sh',
}

# exec { 'install quicklisp':
#   command => '/usr/bin/sudo -u vagrant sh -c "cd /home/vagrant; ./sbcl-ql-setup.sh"',
#   require => [ File['sbcl-ql-install.lisp'],
#                File['sbcl-ql-setup.sh'],
#                File['emacs-dir'],
#                Package['sbcl'],
#                Exec['download quicklisp'],  ],
# }
