filebucket { 'main':
  server => $::settings::server,
  path   => false,
}

File { backup => 'main' }

## Resource default for the vcsrepo type.  Keep it from complaining.
Vcsrepo {
  provider => 'git',
}

## PE 3.3 introduces 'allow_virtual' to the package resource type, which
## will cause warnings.  Set this to true to remove the warnings.
Package {
  allow_virtual => true,
}

###############################################################################

node default {

}
