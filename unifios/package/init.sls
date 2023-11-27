# vim: ft=sls

{#-
    Installs a service that runs all executable scripts
    in a directory after boot, syncs this directory from
    the fileserver and enables/starts the service.

    This allows you to sync simple scripts that you require
    to run on each reboot without writing the
    corresponding state file as a mod.

    The service is slightly modified from https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script-2.x
#}

include:
  - .install
