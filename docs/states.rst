Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``unifios``
^^^^^^^^^^^
*Meta-state*.

This installs a service that will run all scripts in
a directory after booting and syncs this directory
from the fileserver.

In addition, you can use this formula to apply some mods
that don't rely on this service or write custom ones.


``unifios.package``
^^^^^^^^^^^^^^^^^^^
Installs a service that runs all executable scripts
in a directory after boot, syncs this directory from
the fileserver and enables/starts the service.

This allows you to sync simple scripts that you require
to run on each reboot without writing the
corresponding state file as a mod.

The service is slightly modified from https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script-2.x


``unifios.mods.authorized_keys``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages SSH keys that can authenticate as root.

Either specify present/absent OR sync.
Just paste the whole key as a list item.


``unifios.mods.certificate``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages a certificate for the GUI.

When using a ``ca_server``, will rely on the SSH wrapper emulation
of ``x509.certificate_managed`` since the remote does not have access
to the event bus.

The wrapper is found in my PR #65654 or in my formula for a private CA:
https://github.com/lkubb/salt-private-ca-formula


``unifios.mods.dns_dnat``
^^^^^^^^^^^^^^^^^^^^^^^^^
Manages a script that ensures firewall rules are in place that redirect
all outgoing TCP/UDP packets directed to port 53 and originating from
select interfaces/subnets to a specified destination.

In short, ensures that clients on these subnets/interfaces will use
a local DNS resolver (does not account for DoH/DoT etc.).


``unifios.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``unifios`` meta-state
in reverse order, i.e. removes mods and scripts, stops
and removes the on_boot service.


``unifios.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops and disables the on_boot service, removes synced scripts
and the corresponding unit file.


``unifios.mods.authorized_keys.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes wanted SSH keys for the root account.
If this removes all of them, you will have to login
using the password specified in the GUI.


``unifios.mods.certificate.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Does not remove the certificate/key because this would break
the UI service. You will need to do this manually.


``unifios.mods.dns_dnat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Disables dns_nat service and timer and removes all related files.


