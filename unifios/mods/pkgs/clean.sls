# vim: ft=sls

{#-
    Removes wanted system packages.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


Wanted system packages are absent:
  pkg.absent:
    - names:
{%- for pkg in unifios.pkgs.present %}
{%-   if pkg is string %}
      - {{ pkg }}
{%-   else %}
      - {{ pkg | list | first }}
{%-   endif %}
