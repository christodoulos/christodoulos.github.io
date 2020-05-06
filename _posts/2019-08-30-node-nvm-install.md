---
layout: post
title: Node installation using NVM
tags:
  - nvm
  - Node.js
---

Install NVM by running the following in Terminal:

```bash
git clone git://github.com/creationix/nvm.git ~/.nvm
printf "\n\n# NVM\nif [ -s ~/.nvm/nvm.sh ]; then\n\tNVM_DIR=~/.nvm\n\tsource ~/.nvm/nvm.sh\nfi" >> ~/.bashrc
NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh
```

Install Node.js by running the following in Terminal:

```bash
nvm install node
nvm alias default node
nvm use node
```
