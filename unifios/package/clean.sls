# vim: ft=sls

{#-
    Stops and disables the on_boot service, removes synced scripts
    and the corresponding unit file.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}

UniFi OS on-boot service is dead:
  service.dead:
    - name: uosb
    - disable: true

UniFi OS on-boot is absent:
  file.absent:
    - names:
      - /etc/systemd/system/uosb.service
      - /data/on_boot.d
