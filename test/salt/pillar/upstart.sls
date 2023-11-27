# vim: ft=yaml
---
unifios:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    cert:
      crt_path: unifi-core/config/unifi-core.crt
      key_path: unifi-core/config/unifi-core.key
    script_dir: /data/scripts
  authorized_keys:
    absent: []
    present: []
    sync: []
  cert:
    ca_server: null
    certificate_managed:
      authorityKeyIdentifier: keyid:always
      basicConstraints: critical, CA:false
      days_remaining: 7
      days_valid: 30
      subjectKeyIdentifier: hash
    private_key_managed:
      algo: rsa
      keysize: 3072
      new: true
    signing_policy: null
  dns_dnat:
    dest: null
    forced_interfaces: []
    forced_subnets: []
    hairpin_snat: null
    timer:
      OnCalendar: '*:0/5'
      Persistent: true
  mods: []
  on_boot_service: true

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://unifios/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   unifios-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      unifios-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value