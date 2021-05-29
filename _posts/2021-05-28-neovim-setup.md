---
title: neovim setup
layout: post
code: true
---

# Initial install and configuration

sudo apt install neovim

mkdir .config/nvim
touch .config/nvim/init.vim

nvim
checkhealth
...
## Python 2 provider (optional)
  - WARNING: No Python executable found that can `import neovim`. Using the first available           executable for diagnostics.
  - ERROR: Python provider error:
    - ADVICE:
      - provider/pythonx: Could not load Python 2:
          python2 not found in search path or not executable.
          python2.7 not found in search path or not executable.
          python2.6 not found in search path or not executable.
          python not found in search path or not executable.
  - INFO: Executable: Not found
...

sudo apt install python2.7 python3-pip
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py

python2.7 get-pip.py

DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. pip 21.0 will drop support for Python 2.7 in January 2021. More details about Python 2 support in pip can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support pip 21.0 will remove support for this functionality.
Defaulting to user installation because normal site-packages is not writeable
Collecting pip<21.0
  Using cached pip-20.3.4-py2.py3-none-any.whl (1.5 MB)
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 20.3.4
    Uninstalling pip-20.3.4:
      Successfully uninstalled pip-20.3.4
Successfully installed pip-20.3.4

pip2 install neovim

nvim check health
...
## Python 3 provider (optional)
  - INFO: `g:python3_host_prog` is not set.  Searching for python3 in the environment.
  - INFO: Multiple python3 executables found.  Set `g:python3_host_prog` to avoid surprises.
  - INFO: Executable: /bin/python3
  - INFO: Other python executable: /usr/bin/python3
  - INFO: Python version: 3.8.5
  - INFO: pynvim version: 0.4.1 (outdated; from /usr/lib/python3/dist-packages/neovim)
  - WARNING: Latest pynvim is NOT installed: 0.4.3
...

sudo apt install python3-pip
sudo apt purge python3-neovim python3-pynvim

...
The following packages were automatically installed and are no longer required:
  python3-greenlet python3-msgpack
Use 'sudo apt autoremove' to remove them.
...

sudo apt autoremove

pip3 install pynvim

gem install neovim

npm install -g neovim

nvim checkhealth ALL OK

# Plugin manager

Vim Plug install

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

init.vim

" Plugin Manager
call plug#begin('~/.vim/plugged')
call plug#end()

coc nvim:
Plug 'neoclide/coc.nvim', {'branch': 'release'}

:CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css

