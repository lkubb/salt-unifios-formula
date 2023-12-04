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
{%- set init_mods = ["pkgs", "pip_pkgs"] %}

include:
{%- if unifios.on_boot_service %}
  - .package
{%- endif %}
{%- for mod in init_mods %}
{%-   if mod in unifios.mods %}
  - .mods.{{ mod }}
{%-   endif %}
{%- endfor %}
{%- for mod in unifios.mods %}
{%-   if mod not in init_mods %}
  - .mods.{{ mod }}
{%-   endif %}
{%- endfor %}
