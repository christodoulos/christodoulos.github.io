---
title: GIT cheatsheet
layout: post
code: true
---

## How to create a new local branch

First, let’s say you’re working on your project and have a couple of commits already on the master branch.

```
C0 <-- C1 <-- C2 <-- master
```

You’ve decided that you’re going to work on issue #53 in whatever issue-tracking system your company uses. To create a new branch and switch to it at the same time, you can run the `git checkout` command with the `-b` switch:

```
$ git checkout -b iss53
Switched to a new branch "iss53"
```

This is shorthand for:

```
$ git branch iss53
$ git checkout iss53
```

A new branch pointer is created:

```
C0 <-- C1 <-- C2 <-- master
               ^
               |---- iss53
```

## How to delete a local branch

In some cases, Git might refuse to delete your local branch: when it contains commits that haven't been merged into any other local branches or pushed to a remote repository. This is a very sensible rule that protects you from inadvertently losing commit data.

```bash
$ git branch -d <local-branch>
```