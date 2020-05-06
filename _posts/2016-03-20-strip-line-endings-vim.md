---
title: VIM tips
tags: linux, vim, tip
---

# How to strip DOS line endings

In vim's command mode, type:

```
:%s/^M$//
```

(To get `^M`, press `^V^M`, where `^` is `Ctrl` on most keyboards). In order to avoid the `^V^M` hassle you can also type (saves two characters):

```
:%s/\r$
```