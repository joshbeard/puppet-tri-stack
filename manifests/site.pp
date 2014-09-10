filebucket { 'main':
  server => $::settings::server,
  path   => false,
}

File { backup => 'main' }


Vcsrepo {
  provider => 'git',
}

Package {
  allow_virtual => true,
}

node default {

}
