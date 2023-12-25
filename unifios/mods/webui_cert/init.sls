# vim: ft=sls

{#-
    Manages a certificate for the GUI.

    When using a ``ca_server``, will rely on the SSH wrapper emulation
    of ``x509.certificate_managed`` since the remote does not have access
    to the event bus.

    The wrapper is found in my PR #65654 or in my formula for a private CA:
    https://github.com/lkubb/salt-private-ca-formula
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}

{%- set crt_file = unifios.lookup.datadir | path_join(unifios.lookup.cert.crt_path) %}
{%- set key_file = unifios.lookup.datadir | path_join(unifios.lookup.cert.key_path) %}

{%- if unifios.cert.ca_server %}
{%-   set pk_managed = salt["defaults.deepcopy"](unifios.cert.private_key_managed) %}
{%-   do pk_managed.update({"name": key_file, "user": "root", "group": "unifi", "mode": "0640", "makedirs": true}) %}
{%-   set cert_managed = salt["defaults.deepcopy"](unifios.cert.certificate_managed) %}
{%-   do cert_managed.update({"user": "root", "group": "unifi"}) %}
{{
    salt["x509.certificate_managed_wrapper"](
      crt_file,
      ca_server=unifios.cert.ca_server,
      signing_policy=unifios.cert.signing_policy,
      private_key_managed=pk_managed,
      certificate_managed=unifios.cert.certificate_managed,
      test=opts.get("test")
    ) | yaml(false)
}}

{%- else %}

{{ key_file }}_key:
  x509.private_key_managed:
    - name: {{ key_file }}
    {{ unifios.cert.private_key_managed | dict_to_sls_yaml_params | indent(4) }}
{%-   if unifios.cert.private_key_managed.get("new") and salt["file.file_exists"](key_file) %}
    - prereq:
      - x509: {{ crt_file }}
{%-   endif %}

{{ crt_file }}_crt:
  x509.certificate_managed:
    - name: {{ crt_file }}
    - signing_policy: {{ unifios.cert.signing_policy or "null" }}
    - private_key: {{ key_file }}
    {{ unifios.cert.certificate_managed | dict_to_sls_yaml_params | indent(4) }}
{%-   if "signing_private_key" not in unifios.cert.certificate_managed %}
    # This will be a self-signed certificate
    - signing_private_key: {{ key_file }}
{%-   endif %}
    - mode: '0640'
    - user: root
    - group: unifi
    - makedirs: true
{%-   if not unifios.cert.private_key_managed.get("new") or not salt["file.file_exists"](key_file) %}
    - require:
      - x509: {{ key_file }}
{%-   endif %}
{%- endif %}

Unifi service is restarted:
  service.running:
    - name: unifi-core
    - enable: true
    - watch:
      - x509: {{ crt_file }}
