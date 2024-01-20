# vim: ft=sls

{#-
    The login API has several rate limits. For automations, especially
    the success login rate limit can be detrimental - you will receive
    HTTP 429 Too Many Requests if the client does not do caching.
    This state manages the mentioned rate limit as configured.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as unifios with context %}


API successful login rate limit is managed:
  file.replace:
    - name: /usr/lib/ulp-go/config.props
    - pattern: '^success\.login\.limit\.count = \d+$'
    - repl: success.login.limit.count = {{ unifios.api_ratelimit.login_success }}

Unifi login service is restarted:
  service.running:
    - name: ulp-go
    - enable: true
    - watch:
      - file: /usr/lib/ulp-go/config.props
