Ubuntu:

admi
Adm2025_
123abc
usa002
Adm2025?

Rocky:
123abc / Adm2025?
usa002
Adm2025?

OpenSUSE:
root
Adm2025_
Adm2025?

RHEL:
Adm2025?
usa002
Adm2025?

```conf
$ cat /etc/krb5.conf
[libdefaults]
    default_realm = MARCOS.LOC
    rdns = no
    dns_lookup_kdc = true
    dns_lookup_realm = false
    udp_preference_limit = 0

[realms]
    MARCOS.LOC = {
        kdc = 192.168.100.100
        admin_server = 192.168.100.100
        default_domain = marcos.loc
    }

[domain_realm]
    .marcos.loc = MARCOS.LOC
    marcos.loc  = MARCOS.LOC
```