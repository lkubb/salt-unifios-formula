.. _readme:

UniFi OS Formula
================

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage UniFi OS with Salt.

Provides several mods that are intended to run on UniFi OS 3.x.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This formula is intended to be executed via ``salt-ssh``.
* Note that for UniFi OS 2.x, the inbuilt Python is too old for current Salt.
* If a mod installs a script, it will usually install a Sytemd service and possibly timer unit with it to schedule runs.
* It currently relies heavily on wrapper modules that are not yet part of Salt core, but are submitted in several of my PRs.
* If you want to interact with certificates, you will need to install the ``python3-cryptography`` package before running ``salt-ssh``.

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


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


``unifios.helpers.pip_pkgs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On Debian, installing pip pulls in a lot of dependencies.
Installing pure Python or pre-compiled wheels for the platform
does not require them though.

This state downloads the ``pip`` wheel and uses it to install
other specified packages without pulling all those dev dependencies.
The specified packages **must** either be pure Python packages
or have binary wheel distributions for the platform (``aarch64``).


``unifios.mods.api_ratelimit``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The login API has several rate limits. For automations, especially
the success login rate limit can be detrimental - you will receive
HTTP 429 Too Many Requests if the client does not do caching.
This state manages the mentioned rate limit as configured.


``unifios.mods.authorized_keys``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages SSH keys that can authenticate as root.

Either specify present/absent OR sync.
Just paste the whole key as a list item.

This is just a helper. For more comprehensive OpenSSH management,
I would advise using https://github.com/lkubb/salt-openssh-formula,
which works with Salt-SSH.


``unifios.mods.dns_dnat``
^^^^^^^^^^^^^^^^^^^^^^^^^
Manages a script that ensures firewall rules are in place that redirect
all outgoing TCP/UDP packets directed to port 53 and originating from
select interfaces/subnets to a specified destination.

In short, ensures that clients on these subnets/interfaces will use
a local DNS resolver (does not account for DoH/DoT etc.).


``unifios.mods.pip_pkgs``
^^^^^^^^^^^^^^^^^^^^^^^^^
Installs global Python packages with ``pip``.

Note that pip is not installed by default. You can either install the
``python3-pip`` system package or use `unifios.helpers.pip_pkgs`_
to avoid pulling in a lot of dev dependencies.


``unifios.mods.pkgs``
^^^^^^^^^^^^^^^^^^^^^
Manages installed system packages.


``unifios.mods.webui_cert``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages a certificate for the GUI.

When using a ``ca_server``, will rely on the SSH wrapper emulation
of ``x509.certificate_managed`` since the remote does not have access
to the event bus.

The wrapper is found in my PR #65654 or in my formula for a private CA:
https://github.com/lkubb/salt-private-ca-formula


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


``unifios.helpers.pip_pkgs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes pip and wanted packages.


``unifios.mods.api_ratelimit.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Resets managed rate limits to defaults.


``unifios.mods.authorized_keys.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes wanted SSH keys for the root account.
If this removes all of them, you will have to login
using the password specified in the GUI.


``unifios.mods.dns_dnat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Disables dns_nat service and timer and removes all related files.


``unifios.mods.pip_pkgs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes wanted pip packages.


``unifios.mods.pkgs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes wanted system packages.


``unifios.mods.webui_cert.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Does not remove the certificate/key because this would break
the UI service. You will need to do this manually.



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
