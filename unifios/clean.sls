# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``unifios`` meta-state
    in reverse order, i.e. removes mods and scripts, stops
    and removes the on_boot service.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


include:
{%- for mod in unifios.mods %}
  - mods.{{ mod }}.clean
{%- endfor %}
{%- if unifios.on_boot_service %}
  - .package.clean
{%- endif %}
