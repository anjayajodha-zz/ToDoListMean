group { 'web':
  ensure => 'present',
  gid    => '1002',
}

node default {
  class { 'nodejs':
    repo_url_suffix => '5.x',
  }
  class {'::mongodb::server':
    verbose => 'true',
  }
}

package { 'express':
  ensure   => 'present',
  provider => 'npm',
}

package { 'forever':
  ensure   => 'present',
  provider => 'npm',
}

package { 'git':
  ensure   => 'latest',
}

package {'nodemon':
  ensure   => 'present',
  provider => 'npm'
}

vcsrepo { '/todolistmean' :
  ensure   => 'latest',
  provider => 'git',
  source   => 'https://github.com/anjayajodha/ToDoListMean.git',
  revision => 'master',
} ~>
exec { 'installdeps' :
  command => 'npm install',
  cwd     => '/todolistmean/ToDoListMean',
  user    => 'root',
  path    => '/usr/bin',
} ->
exec { 'restartnode' :
  command => 'killall nodejs;forever start server.js;',
  cwd     => '/todolistmean/ToDoListMean',
  user    => 'root',
  path    => '/usr/bin',
}
