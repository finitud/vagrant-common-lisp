exec { 'initial update': 
  command => '/usr/bin/apt-get update',
}

package { 'curl':
  ensure => present,
  require => Exec['initial update'],
}

package { 'python-software-properties':
  ensure => present,
  require => Package['curl'],
}

exec { 'add emacs repository':
  command => '/usr/bin/add-apt-repository ppa:cassou/emacs -y',
  require => Package['python-software-properties'],
}

exec { 'second update':
  command => '/usr/bin/apt-get update',
  require => Exec['add emacs repository'],
}

package { 'emacs24':
  ensure => present,
  require => Exec['second update'],
}

package { 'emacs24-el':
  ensure => present,
  require => Exec['second update'],
}

package { 'emacs24-common-non-dfsg':
  ensure => present,
  require => Exec['second update'],
}

package { 'git-core':
  ensure => present,
  require => Exec['second update'],
}

package { 'sbcl':
  ensure => present,
  require => Package['git-core'],
}

package { 'sbcl-doc':
  ensure => present,
  require => Package['git-core'],
}

package { 'sbcl-source':
  ensure => present,
  require => Package['git-core'],
}

exec { 'download quicklisp':
  command => '/usr/bin/curl http://beta.quicklisp.org/quicklisp.lisp -o /tmp/quicklisp.lisp',
  require => Package['curl'],
}

file { 'sbcl-ql-install.lisp':
  path => '/tmp/sbcl-ql-install.lisp',
  ensure => present,
  source => 'puppet:///modules/quicklisp/sbcl-ql-install.lisp',
}

exec { 'install quicklisp':
  command => '/usr/bin/sbcl --load /tmp/sbcl-ql-install.lisp',
  require => File['sbcl-ql-install.lisp'],
}
