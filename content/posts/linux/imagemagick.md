---
title: ImageMagick magic
date: 2014-09-29
tags: [linux, imagemagick]
---

[ImageMagick](https://imagemagick.org/index.php) is an excellent tool for any image manipulation you can imagine. Check out the following commands.

## Add an one pixel black boder around image

```
convert <source image> -shave 1x1 -bordercolor black -border 1 <target image>
```
