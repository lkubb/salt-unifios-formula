# vim: ft=sls

{#-
    *Meta-state*.

    This installs a service that will run all scripts in
    a directory after booting and syncs this directory
    from the fileserver.

    In addition, you can use this formula to apply some mods
    that don't rely on this service or write custom ones.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


include:
{%- if unifios.on_boot_service %}
  - .package
{%- endif %}
{%- for mod in unifios.mods %}
  - .mods.{{ mod }}
{%- endfor %}
