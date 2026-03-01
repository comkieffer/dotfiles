from pyinfra.operations import systemd

systemd.service(
    name="Stop rsyslog service",
    service="rsyslog",
    running=False,
    enabled=False,
)
