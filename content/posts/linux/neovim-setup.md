---
title: Neovim setup
date: 2021-05-28
tags: [linux, vim]
---

## Setup neovim like an IDE

The following setup runs in WSL2 (Ubuntu 20.04) in a Windows 10 machine. Start by installing
neovim and creating an empty configuration file:

```bash
sudo apt install neovim
mkdir .config/nvim
touch .config/nvim/init.vim
```

I proceeded with repeated "checkhealth" commands in neovim and tried to fix the errors. These
were the required steps:

## Python 2 installation

In Ubuntu 20.04 there is neither python2 installed nor a pip2 command available. So I installed
python2 and downloaded the get-pip.py helper script:

```bash
sudo apt install python2.7
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
python2.7 get-pip.py
pip2 install neovim
```

## Python 3 pynvim package upgrade

In Ubuntu 20.04 the pynvim library is outdated. Start by installing pip3 and then purge the
existing pynvim library. The install pynvim using pip3:

```bash
sudo apt install python3-pip
sudo apt purge python3-neovim python3-pynvim
sudo apt autoremove
pip3 install pynvim
```

## Ruby and Nodejs libaries

Towards an error free "checkhealth" command output install the necessary libraries:

```bash
gem install neovim
npm install -g neovim
```

Now your "checkhealth" output must be error free.

## Plugin manager

Vim Plug install

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
 https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Start by editing your `init.vim` file in `.config/nvim`:

```vim
" Plugin Manager
call plug#begin('~/.vim/plugged')
call plug#end()
```

## COC plugin

The COC plugin provides the VSCode like experience. So in your init.vim:

```vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

And then inside neovim:

```vim
:CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css
```
