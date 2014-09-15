# Puppet Control Repository

## Overview

This is a "control repository" for a Puppet installation.

A control repository is responsible for providing Puppet environments and the
data they need to function, including modules and Hiera data.

This control repository makes use of r10k.

When r10k is ran on a master, it will look for branches of this control
repository and make them Puppet environments on a master.  Each branch becomes
a directory on the master, providing environments.  Each environment can
contain different modules and different versions of modules, different
hieradata, etc.

The "Puppetfile" here will be parsed by r10k for each environment, which will
populate each Puppet environment with the modules listed in the Puppetfile.


