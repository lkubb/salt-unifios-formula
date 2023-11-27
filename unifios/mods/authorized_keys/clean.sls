# vim: ft=sls

{#-
    Removes wanted SSH keys for the root account.
    If this removes all of them, you will have to login
    using the password specified in the GUI.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


UniFi OS wanted authorized root keys are absent:
  ssh_auth.absent:
    - names: {{ (unifios.authorized_keys.sync or unifios.authorized_keys.present) | json }}
    - user: root
