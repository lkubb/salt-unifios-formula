# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``unifios`` meta-state
    in reverse order, i.e. removes mods and scripts, stops
    and removes the on_boot service.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- set init_mods = ["pkgs", "pip_pkgs"] %}


include:
{%- for mod in unifios.mods %}
{%-   if mod not in init_mods %}
  - .mods.{{ mod }}
{%-   endif %}
{%- endfor %}
{%- for mod in init_mods %}
{%-   if mod in unifios.mods %}
  - .mods.{{ mod }}
{%-   endif %}
{%- endfor %}
{%- if unifios.on_boot_service %}
  - .package.clean
{%- endif %}
