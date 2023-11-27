# vim: ft=sls

{#-
    Disables dns_nat service and timer and removes all related files.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- from tplroot ~ "/macros.jinja" import systemd_script_clean with context %}

{%- set clean_script = unifios.lookup.script_dir | path_join("dns_dnat_remove.sh") %}
{%- if salt["file.file_exists"](clean_script) %}

# Ensure that if the requested rules change, we don't leave
# outdated ones behind.
Previous DNS DNAT rules have been cleaned up:
  cmd.script:
    - name: {{ clean_script }}
    - order: first
{%- endif %}

{{ systemd_script_clean("dns_dnat", unifios, timer=true) }}

{{ systemd_script_clean("dns_dnat_remove", unifios, service=false) }}
