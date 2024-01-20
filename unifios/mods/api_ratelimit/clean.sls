# vim: ft=sls

{#-
    Resets managed rate limits to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


API successful login rate limit is managed:
  file.replace:
    - name: /usr/lib/ulp-go/config.props
    - pattern: '^success\.login\.limit\.count = \d+$'
    - repl: success.login.limit.count = 5

Unifi login service is restarted:
  service.running:
    - name: ulp-go
    - enable: true
    - watch:
      - file: /usr/lib/ulp-go/config.props
