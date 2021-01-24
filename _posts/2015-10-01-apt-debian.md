---
title: How to remove apt-key added keys
layour: post
tags: linux, debian, apt-key
---

#### How to remove apt-key added keys

During a normal day to day debian usage you may add various apt repository keys using commands like

```bash
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 90127F5B
```

Later on you realize that you don't need the repository anymore or that the package you expected to exist in the repository is not finally present! (the latter actually happened to me when I added the above key and expected to install a gnome 3 theme)

In order to delete a certain key you have to find the key's id. Do that by using the command:

```bash
sudo apt-key list
```

All the keys that you have will be listed with entries looking like:

```bash
pub   4096R/90127F5B 2012-05-30 [expires: 2016-05-29]
uid                  Unofficial Apache OpenOffice Debian repository <apacheoo-deb-devel@lists.sourceforge.net>
sub   4096R/0A8A56B5 2012-05-30 [expires: 2016-05-29]
```

Once you have figured out the key's id (ok, if you just added the key you already know its id, but you may have forgotten it or you may utilize the key's description) you remove it from your keyring issuing the following command:

```bash
sudo apt-key del 90127F5B
```