# vim: ft=sls

{#-
    Manages installed system packages.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


Wanted system packages are present:
  pkg.installed:
    # using names instead of pkgs to be able to override
    # params for this state
    - names: {{ unifios.pkgs.present | json }}

Unwanted system packages are absent:
  pkg.absent:
    - pkgs: {{ unifios.pkgs.absent | json }}
