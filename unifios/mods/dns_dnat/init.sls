# vim: ft=sls

{#-
    Manages a script that ensures firewall rules are in place that redirect
    all outgoing TCP/UDP packets directed to port 53 and originating from
    select interfaces/subnets to a specified destination.

    In short, ensures that clients on these subnets/interfaces will use
    a local DNS resolver (does not account for DoH/DoT etc.).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- from tplroot ~ "/macros.jinja" import put_script with context %}

{%- set clean_script = unifios.lookup.script_dir | path_join("dns_dnat_remove.sh") %}
{%- if salt["file.file_exists"](clean_script) %}

# Ensure that if the requested rules change, we don't leave
# outdated ones behind.
Previous DNS DNAT rules have been cleaned up:
  cmd.script:
    - name: {{ clean_script }}
    - prereq:
      - file: {{ unifios.lookup.script_dir | path_join("dns_dnat.sh") }}
{%- endif %}


{{ put_script("dns_dnat", unifios, timer=true) }}

{{ put_script("dns_dnat_remove", unifios, service=false) }}
