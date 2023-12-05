# vim: ft=sls

{#-
    Manages SSH keys that can authenticate as root.

    Either specify present/absent OR sync.
    Just paste the whole key as a list item.

    This is just a helper. For more comprehensive OpenSSH management,
    I would advise using https://github.com/lkubb/salt-openssh-formula,
    which works with Salt-SSH.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}

{%- if unifios.authorized_keys.sync %}

UniFi OS authorized root keys are synced:
  ssh_auth.manage:
    - user: root
    - ssh_keys: {{ unifios.authorized_keys.sync | json }}

{%- else %}

UniFi OS unwanted authorized root keys are absent:
  ssh_auth.absent:
    - names: {{ unifios.authorized_keys.absent | json }}
    - user: root

UniFi OS wanted authorized root keys are present:
  ssh_auth.present:
    - names: {{ unifios.authorized_keys.present | json }}
    - user: root
{%- endif %}
