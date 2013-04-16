# puppet-csync2

## Overview

Install, enable and configure csync2. For more information, see
http://oss.linbit.com/csync2/

* `csync2` : Main class to install and enable the server.

This module requires another module to manage the xinetd configuration. See
examples below for the thias-xinetd module.

You will also need to allow all nodes to access 30865/tcp on each node.

## Examples

