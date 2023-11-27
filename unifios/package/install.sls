# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

UniFI OS on-boot.d dir is present:
  file.directory:
    - name: /data/on_boot.d
    - user: root
    - group: root
    - mode: '0755'

UniFi OS on-boot service is installed:
  file.managed:
    - name: /etc/systemd/system/uosb.service
    - source: {{ files_switch(
                    ["uosb.service", "uosb.service.j2"],
                    config=unifios,
                    lookup="UniFi OS on-boot service is installed",
                 )
              }}
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: /data/on_boot.d

UniFI OS on-boot.d scripts are synced:
  file.recurse:
    - name: /data/on_boot.d
    - source: {{ files_switch(
                    ["on_boot.d"],
                    config=unifios,
                    lookup="UniFi OS on-boot service is installed",
                 )
              }}
    - exclude_pat: '.gitkeep'
    - user: root
    - group: root
    - file_mode: keep
    - require:
      - UniFI OS on-boot.d dir is present

UniFi OS on-boot service is running:
  service.running:
    - name: uosb
    - enable: true
    - require:
      - file: /etc/systemd/system/uosb.service
    - watch:
      - UniFI OS on-boot.d scripts are synced
