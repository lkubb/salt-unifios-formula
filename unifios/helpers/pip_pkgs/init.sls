# vim: ft=sls

{#-
    On Debian, installing pip pulls in a lot of dependencies.
    Installing pure Python or pre-compiled wheels for the platform
    does not require them though.

    This state downloads the ``pip`` wheel and uses it to install
    other specified packages without pulling all those dev dependencies.
    The specified packages **must** either be pure Python packages
    or have binary wheel distributions for the platform (``aarch64``).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

{%- if unifios.pip.remote_source.url %}
{%-   set pip_data_rls = {
        "url": unifios.pip.remote_source.url,
        "digests": {
          "sha256": unifios.pip.remote_source.digest
        }
      }
%}
{%- else %}
{%-   set pip_data = salt["http.query"](unifios.lookup.pip.releases_url, decode=True).dict %}
{%-   if unifios.pip.release == "latest" %}
{%-     set pip_data_rls = pip_data.urls[0] %}
{%-   else %}
{%-     set pip_data_rls = pip_data.releases[unifios.pip.release][0] %}
{%-   endif %}
{%- endif %}

{%- set prev_pip_dist_info = salt["file.find"](unifios.lookup.pip.dist_packages, type="d", name="pip*.dist-info") %}

Pip wheel package is present:
  file.managed:
    - name: {{ unifios.lookup.working_dir | path_join("pip_wheel.whl") }}
    - source: {{ files_switch(
                    ["pip.whl"],
                    config=unifios,
                    lookup="Pip wheel is present",
                 )
              }}
{%- if pip_data_rls %}
      - {{ pip_data_rls.url }}
    - source_hash: {{ pip_data_rls.digests.sha256 }}
{%- endif %}
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true

Previous pip is cleaned:
  file.absent:
    - names:
      - {{ unifios.lookup.pip.dist_packages | path_join("pip") }}
{%- if prev_pip_dist_info %}
      - {{ prev_pip_dist_info[0] }}
{%- endif %}
    - onchanges:
      - file: {{ unifios.lookup.working_dir | path_join("pip_wheel.whl") }}

# Sadly, Salt does not seem to be capable of using pip from inside a zip (whl)
# Not using archive.extracted directly because it's brittle from my experience
Pip is installed:
  archive.extracted:
    - name: {{ unifios.lookup.pip.dist_packages }}
    - source: {{ unifios.lookup.working_dir | path_join("pip_wheel.whl") }}
    - enforce_toplevel: false
    - archive_format: zip
    - require:
      - Previous pip is cleaned
    - onchanges:
      - file: {{ unifios.lookup.working_dir | path_join("pip_wheel.whl") }}

Pip modules should now work:
  module.run:
    - name: sys.reload_modules
    - onchanges:
      - Pip is installed
