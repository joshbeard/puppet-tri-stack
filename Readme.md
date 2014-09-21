# Puppet Control Repository
## Vagrant environment

**This is a work in progress**

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

## Architecture

This control repository is also developed to create a split stack Puppet
Enterprise infrastructure.  It includes a bootstrap helper script along with
some pre-developed "profiles" for configuring the PE servers.

This sets up two "locations", both with their own PE infrastructure but shared
resources between them.

**Site 1:**

* Primary CA/Master + ActiveMQ broker
* PuppetDB + Active PostgreSQL
* Console + Active PostgreSQL
* Additional compile master + ActiveMQ broker

**Site 2:**

* Secondary CA/Master + ActiveMQ broker
* PuppetDB + Standby PostgreSQL
* Console + Standby PostgreSQL
* Additional compile master + ActiveMQ broker

Several CNAMEs are used to ensure services are able to be dynamically pointed
as needed for HA, scalability, and disaster recovery.  Ideally, a load balancer
or traffic manager would be available to handle such needs.

This makes heavy use of my `pe_server` module, available at
[https://github.com/joshbeard/pe_server](https://github.com/joshbeard/pe_server)

## Bootstrap helper

There's a bootstrap helper script in in the `bootstrap/` directory.  This is
fairly simple - it just does some sanity checking and calls the native PE
installer with the appropriate answer file for the PE server "role" that's
getting built.  It also prompts to perform certificate tasks at the appropriate
spots and provides guidance.  No magic here, just guidance.

The answer files are pre-created in the `bootstrap/answers/` directory. There's
a `common.txt` file there with variables set to define the right host addresses
to use for the PE services.  The other answer files source that.  This is
simply for convenience.  Again, no magic.

## Vagrant Testing

Bring up each system in the following order:

1. puppetca01
2. puppetdb01
3. puppetconsole01
4. puppetca02
5. puppetdb02
6. puppetconsole02

There's a bootstrap helper script (`bootstrap/boostrap.sh`) that will be made
available to each instance at `/vagrant/bootstrap/`.

Login to each system and execute the bootstrap helper script.  Install the
appropriate role for the system you're logged into.

The bootstrap helper script will provide the guidance to stand up the stack.

Manual instructions for this (without the use of the bootstrap helper) will
be provided later.

An Internet connection is required to use this, as dependencies will be
downloaded during installation and bootstrapping.

## Errors during bootstrap

There's a few warnings and errors that you'll see during the boostrap that are
harmless and due to how we're doing this.  Obviously, you should evaluate each
of them and determine if it's something that prevents the bootstrap or not.
Here's a few of the ones to expect:

> Warning: You cannot collect without storeconfigs being set on line ....

This is just indicating that one of our Puppet classes is trying to collect
exported resources, but PuppetDB isn't available because we're doing a
`puppet apply`.  This is okay to ignore during bootstrap or when doing a
`puppet apply`

> Warning: The package type's allow_virtual parameter will be changing its default value from false to true in a future release. If you do not want to allow virtual packages ...

This is a deprecation warning that appears in Puppet Enterprise 3.3.x.  It's
harmless and just indicating that the `package` type has a behavior change.
Once the systems are all stood up and Puppet is doing normal agent runs against
a master, this warning should silence, as we've added the `allow_virtual`
parameter to the `package` type resource defaults in `site.pp`

> Error: Could not request certificate: Error 400 on SERVER: CSR '...' contains subject alternative names ....

This is just indicating that the certificate could not be automatically signed
by our CA because it contains alternate names.  This is a security feature.
You'll have to manually sign the certificate with alternate names, and the
bootstrap helper should prompt you when and how to do that.

> Warning: Unable to fetch my node definition, but the agent run will continue:
> Warning: Error 400 on SERVER: No route to host - connect(2)

This is due to an unavailable console.  When an agent runs during bootstrap,
the master attempts to reach a console.  If the console is not fully bootstrapped
yet, you'll see this error.  It's okay until the stack is fully built and ready.

> Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Failed to submit 'replace facts' command for .... to PuppetDB at puppetdbhost:8081: Connection refused - connect(2)

This is just indicating that PuppetDB is unavailable.  You'll see this during
bootstrapping before PuppetDB has had a chance to be fully configured and started.

> Warning: Scope(Concat::Fragment[.....]): The $mode parameter to concat::fragment is deprecated and has no effect

This is due to the `concat` module having a changed behavior.  No big deal
during bootstrap, and should go away after things are provisioned.

> (whole bunch of HTML)
> You are not authorized to access this page

The console isn't fully provisioned.

> Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Could not find class pe_mcollective for ...

Once the primary stack is provisioned, make sure there's a "production"
environment in `/etc/puppetlabs/puppet/environments/`


## Authors

Josh Beard, [beard@puppetlabs.com](mailto:beard@puppetlabs.com)

Special nod to [Tom Linkin](https://github.com/trlinkin/) for his work on the
[pe_secondary](https://github.com/trlinkin/pe_secondary) module.

Also to [Zack Smith](https://github.com/acidprime/) for some bootstrap
methodologies.
