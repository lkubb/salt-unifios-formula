# vim: ft=sls

{#-
    Installs global Python packages with ``pip``.

    Note that pip is not installed by default. You can either install the
    ``python3-pip`` system package or use `unifios.helpers.pip_pkgs`_
    to avoid pulling in a lot of dev dependencies.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


Wanted pip packages are present:
  pip.installed:
    # using names instead of pkgs to be able to override
    # params for this state
    - names: {{ unifios.pip.pkgs | json }}

Unwanted pip packages are absent:
  pip.removed:
    - names: {{ unifios.pip.pkgs_absent | json }}
