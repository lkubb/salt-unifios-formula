# vim: ft=sls

{#-
    Removes pip and wanted packages.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- set prev_pip_dist_info = salt["file.find"](unifios.lookup.pip.dist_packages, type="d", name="pip*.dist-info") %}


Wanted pip pkgs are absent:
  pip.installed:
    - names:
{%- for pkg in unifios.pip.pkgs %}
{%-   if pkg is string %}
      - {{ pkg }}
{%-   else %}
      - {{ pkg | list | first }}
{%-   endif %}

Pip is uninstalled:
  file.absent:
    - names:
      - {{ unifios.lookup.working_dir | path_join("pip_wheel.whl") }}
      - {{ unifios.lookup.pip.dist_packages | path_join("pip") }}
{%- if prev_pip_dist_info %}
      - {{ prev_pip_dist_info[0] }}
{%- endif %}
    - require:
      - Wanted pip pkgs are absent
