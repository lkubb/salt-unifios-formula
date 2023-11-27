# vim: ft=sls

{#-
    Does not remove the certificate/key because this would break
    the UI service. You will need to do this manually.
#}


Certificate should not be cleaned:
  test.show_notification:
    - text: |
        Removing the generated certificate is only possible manually.
        You will need to create a new certificate at
        {{ unifios.lookup.datadir | path_join(unifios.lookup.cert.crt_path) }}
        and manually restart the service.
        For >= v2: systemctl restart unifi
