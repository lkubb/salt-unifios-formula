# vim: ft=sls

{#-
    Removes wanted pip packages.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


Wanted pip packages are absent:
  pip.absent:
    - names:
{%- for pkg in unifios.pip.pkgs %}
{%-   if pkg is string %}
      - {{ pkg }}
{%-   else %}
      - {{ pkg | list | first }}
{%-   endif %}
