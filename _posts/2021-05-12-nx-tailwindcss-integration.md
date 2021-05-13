---
title: NX tailwindcss integration
layout: post
code: true
---

## About tailwindcss

blah blah

## NX tailwindcss integration

We create a new branch `tailwindcss` to hold the upcoming changes of the `main` branch:

```bash
$ git checkout -b tailwindcss
Switched to a new branch 'tailwindcss'
```

[`@ngneat/tailwind`](https://github.com/ngneat/tailwind) is an angular schematic that adds [Tailwind CSS](https://tailwindcss.com/) to our NX workspace. We install `@ngneat/tailwind` first:

```bash
$ npm i -D @ngneat/tailwind tailwindcss postcss autoprefixer
<several lines truncated>
+ postcss@8.2.15
+ autoprefixer@10.2.5
+ tailwindcss@2.1.2
+ @ngneat/tailwind@7.0.3
added 46 packages from 63 contributors, removed 1 package, updated 2 packages and audited 1988 packages in 30.339s
<several lines truncated>
```

The installation process might find some vulnerabilities of varying severity. We can issue the `npm audit` command for details and try to fix them using the `npm audit fix` command.

When we wrote the post, there was a bug in the schematic affecting the dark mode option. A workaround was to define the dark mode setting in the command line. We execute the schematic:

```bash
$ nx generate @ngneat/tailwind:nx-setup  --darkMode=none
✔ What project would you like to use? (skip to use default project) · authoring
✔ Would you like to enable Tailwind JIT (preview feature)? (y/N) · false
    ✔ Added tailwindcss@2.1.2
CREATE tailwind.config.js
UPDATE apps/authoring/src/styles.css
```

