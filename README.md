# puppet-csync2

## Overview

Install, enable and configure csync2. For more information, see
http://oss.linbit.com/csync2/

* `csync2` : Main class to install and enable the server.
* `csync2::cfg` : Simple definition to manage pre-created configuration files.
* `csync2::key` : Simple definition to manage pre-created shared keys.

This module requires another module to manage the xinetd configuration. See
examples below for the thias-xinetd module.

You will also need to allow all nodes to access 30865/tcp on each node.

## Examples

To generate a key file that you can then deploy using puppet :

    csync2 -k example.key

Typical module invocation :

    class { 'csync2':
      cfg_source => 'puppet:///modules/example/csync2/csync2.cfg',
      key_source => 'puppet:///modules/example/csync2/csync2.key',
    }

With the content of `csync2.cfg` being :

    group example {
      host www01.example.com@192.168.12.1;
      host www02.example.com@192.168.12.2;
      host www03.example.com@192.168.12.3;
      key /etc/csync2/csync2.key;
      include /var/www;
    }

Once all nodes have been configured by puppet, run the following on all :

    csync2 -xv

From here, you should either run `csync2 -x` from cron, or have it triggered
by some other program which watches directories for changes using inotify, such
as lsyncd.

If you have more than one configuration on a node, you will want to use the
`csync2::cfg` and `csync2::key` definitions to manage its files :

    csync2::cfg { 'example2':
      source => 'puppet:///modules/example/csync2/csync2_example2.cfg',
    }
    csync2::key { 'example2':
      source => 'puppet:///modules/example/csync2/csync2_example2.key',
    }

Note that in this case, all files have the `csync2_` prefix automatically
added, in order to make things work with the `csync2 -C example2 -xv` syntax.

