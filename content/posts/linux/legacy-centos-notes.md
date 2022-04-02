---
title: CentOS 5.x notes
date: 2014-09-29
tags: [linux, centos]
showTableOfContents: true
---

My personal notebook for CentOS 5.x installations.

## Enable LDAP authentication

If the IP of your LDAP server is `10.10.10.10` and your base dn is `ou=users,dc=yourdomain,dc=com` then the following command enables LDAP authentication:

```bash
authconfig --enableldap --enableldapauth \
           --ldapserver=10.10.10.10      \
           --ldapbasedn=ou=users,dc=yourdomain,dc=com \
           --enablecache --useshadow                  \
           --enablelocauthorize --enablemkhomedir --update
```

## Enable network bonding

You need two network interfaces. Interface `eth0` configuration recides in `/etc/sysconfig/network-scripts/ifcfg-eth0`:

```bash
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
```

The same holds for `eth1` in `/etc/sysconfig/network-scripts/ifcfg-eth1`:

```bash
DEVICE=eth1
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
```

The bonded interface is in `/etc/sysconfig/network-scripts/ifcfg-bond0`

```bash
DEVICE=bond0
BOOTPROTO=dhcp
ONBOOT=yes
```

Finally the bonding mode is set in `/etc/modprobe.conf`:

```bash
...
alias bond0 bonding
options bond0 mode=0 miimon=80
```

## Permit specific incoming connections

The following script permits incoming connections from `192.168.3.10/32` and `192.168.3.3/32`:

```bash
#!/bin/bash
# flush all current rules
iptables -F
# permit ssh only from control station and sgd
iptables -A INPUT -p tcp -s 192.168.3.10/255.255.255.255 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.3.3/255.255.255.255 --dport 22 -j ACCEPT
# drop any other traffic
iptables -P INPUT DROP
iptables -P FORWARD DROP
# permit all outbound traffic
iptables -P OUTPUT ACCEPT
# do not block the lo interface
iptables -A INPUT -i lo -j ACCEPT
# do not block established or related traffic
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# save our settings
/sbin/service iptables save
```

## A minimum set of services

The following script disables a lot of services. Only the bare minimum is left active:

```bash
#!/bin/bash
chkconfig acpid off
chkconfig anacron off
chkconfig atd off
chkconfig auditd off
chkconfig autofs off
chkconfig avahi-daemon off
chkconfig bluetooth off
chkconfig cpuspeed off
chkconfig cups off
chkconfig firstboot off
chkconfig gpm off
chkconfig haldaemon off
chkconfig hidd off
chkconfig hplip off
chkconfig ip6tables off
chkconfig isdn off
chkconfig kudzu off
chkconfig mcstrans off
chkconfig mdmonitor off
chkconfig messagebus off
chkconfig pcscd off
chkconfig rawdevices off
chkconfig readahead_early off
chkconfig restorecond off
chkconfig rpcgssd off
chkconfig rpcidmapd off
chkconfig sendmail off
chkconfig smartd off
chkconfig xfs off
chkconfig yum-updatesd off
```

## Kill zombie GNOME processes

VDI access left behind a lot of zombie processes. The following script kills all of them:

```bash
#!/bin/bash
for P in `ps -ef | tr -s ' ' | egrep -v " ..:.. " | egrep -v "^UID|^root|^rpc|^ntp|^nscd" | tr -s ' ' | cut -d " " -f 2`
do
        kill -9 ${P}
done
```
