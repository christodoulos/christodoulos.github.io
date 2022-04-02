---
date: 2019-02-04
title: LTSP setup for a university classroom
tags: [linux, ubuntu, ltsp]
---

Warning: _This is my personal notepad for such installations.  
Use it at your own risk!_

## First steps

Start with a _fresh and minimal_ ubuntu installation as it is depicted [here](#!linux/install/install.md#Ubuntu). A functional (but with limited functionality) LTSP server is just a matter of the following commands:

```bash
sudo apt get update
sudo apt get upgrade
sudo apt install ltsp-server-standalone
sudo ltsp-build-client
```

## DHCP server setup

You should configure the network interface from which the server should respond to requests:

```
sudo nano /etc/default/isc-dhcp-server
```

Append a suitable line like the following:

```
INTERFACES="enp3s0"
```

Configure your subnet:

```
sudo nano /etc/ltsp/dhcpd.conf
```

Add a suitable subnet stanza like the following:

```
subnet 147.102.246.0 netmask 255.255.255.0 {
    range 147.102.246.212 147.102.246.213;
    option domain-name "central.ntua.gr";
    option domain-name-servers 147.102.224.243;
    option broadcast-address 147.102.246.255;
    option routers 147.102.246.200;
#    next-server 147.102.246.211;
#    get-lease-hostnames true;
    option subnet-mask 255.255.255.0;
    option root-path "/opt/ltsp/amd64";
    if substring( option vendor-class-identifier, 0, 9 ) = "PXEClient" {
        filename "/ltsp/amd64/pxelinux.0";
    } else {
        filename "/ltsp/amd64/nbi.img";
    }
}
```

Finally restart the server:

```
sudo service isc-dhcp-server start
```

## TFTP server setup

You might need to configure properly the `tftpd-hpa` server:

```
sudo nano /etc/default/tftpd-hpa
```

The file should contain something like the following:

```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure"
```

Start the server if it is not running:

```
sudo service tftpd-hpa start
```

## chroot update/upgrade

You can use the following script to install a specific package in the chroot:

```bash
CHROOT_DIR=/opt/ltsp/amd64

sudo chroot $CHROOT_DIR mount -t proc /proc /proc
sudo chroot $CHROOT_DIR apt update

while [ "$1" != "" ]; do
  sudo chroot $CHROOT_DIR env LTSP_HANDLE_DAEMONS=false apt -y install $1
  shift
done

sudo umount /opt/ltsp/amd64/proc
sudo ltsp-update-image
```

... after a _chroot upgrade_ when a new kernel is installed you should:

```
sudo ltsp-update-sskeys
```

....

## Electronic exams

You can support _electonic exams_ in your _LTSP_ classroom and collect the exam folders using the following script:

```bash
#!/bin/bash
EXAMSDIR=$1
DEPARTMENT=$2
DIRTOCOLLECT=$3
USERS=`ls $EXAMSDIR | grep $2.....`

for USER in $USERS; do
  FULLNAME=`ldapsearch -x "(uid=$USER)" cn | grep cn:: | cut -d" " -f2 | base64 -d 2> /dev/null`
  COLLECTDIR="$USER-$FULLNAME"
  if [ -d $EXAMSDIR/$USER/$DIRTOCOLLECT/ ]; then
    mkdir "$COLLECTDIR"
    cp -r $EXAMSDIR/$USER/$DIRTOCOLLECT/* "$COLLECTDIR"
  else
    if [ -d $EXAMSDIR/$USER/Desktop/$DIRTOCOLLECT/ ]; then
      mkdir "$COLLECTDIR"
      cp -r $EXAMSDIR/$USER/Desktop/$DIRTOCOLLECT/* "$COLLECTDIR"
    else
      echo "$DIRTOCOLLECT not found in $USER's home"
    fi
  fi
done
```

### Squid setup

```
sudo apt install squid
sudo vim /etc/squid/squid.conf

...
# TAG: visible_hostname
#       If you want to present a special hostname in error messages, etc,
#       define this.  Otherwise, the return value of gethostname()
#       will be used. If you have multiple caches in a cluster and
#       get errors about IP-forwarding you must set them to have individual
#       names with this setting.
#Default:
# Automatically detect the system host name
visible_hostname kerveros
...
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
#http_access allow localnet
http_access allow localhost
acl whitelist dstdomain mycourses.ntua.gr physics.ntua.gr
http_access allow whitelist
#http_access allow all
...
```

During your exams it might be usefull to turn the `http_access` rules on and off. In order to enable your whitelist you could run:

```bash
#!/bin/bash
sed -e '/http_access allow whitelist/ s/^#*//' -i /etc/squid/squid.conf
sed -e '/http_access allow all/ s/^#*/#/' -i /etc/squid/squid.conf
service squid restart
```

After the exams you can disable the whitelist:

```bash
#!/bin/bash
sed -e '/http_access allow whitelist/ s/^#*/#/' -i /etc/squid/squid.conf
sed -e '/http_access allow all/ s/^#*//' -i /etc/squid/squid.conf
service squid restart
```

### Firefox lock down

```
vim /usr/lib/firefox/distribution/policies.json
```

```json
{
  "policies": {
    "DisableSetDesktopBackground": true,
    "DisableAppUpdate": true,
    "Homepage": {
      "URL": "http://www.central.ntua.gr",
      "Locked": true
    },
    "Proxy": {
      "Mode": "system",
      "Locked": true
    },
    "SanitizeOnShutdown": true,
    "SearchBar": "unified",
    "DisplayBookmarksToolbar": true,
    "NoDefaultBookmarks": true,
    "DisablePrivateBrowsing": true,
    "DisableBuiltinPDFViewer": true,
    "DisableSetDesktopBackground": true,
    "BlockAboutConfig": true,
    "DisableSecurityBypass": {
      "InvalidCertificate": true,
      "SafeBrowsing": true
    },
    "Bookmarks": [
      {
        "Title": "Κεντρική σελίδα ΕΜΠ",
        "URL": "http://www.ntua.gr",
        "Placement": "toolbar",
        "Folder": "Εθνικό Μετσόβιο Πολυτεχνείο"
      },
      {
        "Title": "Κέντρο Ηλεκτρονικών Υπολογιστών ΕΜΠ",
        "URL": "http://www.central.ntua.gr",
        "Placement": "toolbar",
        "Folder": "Εθνικό Μετσόβιο Πολυτεχνείο"
      },
      {
        "Title": "Κέντρο Δικτύων ΕΜΠ",
        "URL": "http://www.noc.ntua.gr",
        "Placement": "toolbar",
        "Folder": "Εθνικό Μετσόβιο Πολυτεχνείο"
      },
      {
        "Title": "Ηλεκτρονικές Σελίδες Μαθημάτων",
        "URL": "http://mycourses.ntua.gr",
        "Placement": "toolbar",
        "Folder": "Εθνικό Μετσόβιο Πολυτεχνείο"
      }
    ]
  }
}
```

### Lock down system proxy settings

Install the necessary package for `dconf` updates:

```
chroot_install dconf-tools
```

Create the following directories:

```
sudo mkdir -p /opt/ltsp/amd64/etc/dconf/profile
sudo mkdir -p /opt/ltsp/amd64/etc/dconf/db/local.d
sudo mkdir /opt/ltsp/amd64/etc/dconf/db/local.d/locks
```

Create a `/opt/ltsp/amd64/etc/dconf/profile/user` file with contents:

```
user-db:user
system-db:local
```

Create a `/opt/ltsp/amd64/etc/dconf/db/local.d/00_proxy_locksettings` file with contents:

```
[system/proxy]
mode='manual'
use-same-proxy=true

[system/proxy/http]
enabled=true
host='server'
port=3128

[system/proxy/https]
host='server'
port=3128

[system/proxy/ftp]
host='server'
port=3128

[system/proxy/socks]
host='server'
port=3128
```

Create a `/opt/ltsp/amd6/etc/dconf/db/local.d/locks/00_proxy_locksettings` file with contents:

```
/system/proxy/mode
/system/proxy/use-same-proxy
/system/proxy/http/enabled
/system/proxy/http/host
/system/proxy/http/port
/system/proxy/https/host
/system/proxy/https/port
/system/proxy/ftp/host
/system/proxy/ftp/port
/system/proxy/socks/host
/system/proxy/socks/port
```

And finally, inside your _chroot_ run:

```
dconf update
```

Dont forget to update your client:

```
sudo ltsp-update-image
```

Warning: If something goes wrong and the _LTSP client's_ GUI does not start, remove the `/opt/ltsp/amd64/etc/dconf` folder and start over again.
