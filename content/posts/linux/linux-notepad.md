---
title: Linux Notepad
date: 2023-05-10
tags: [linux]
---

## File manipulations

### Copy files recursively up to a maximum depth

Say that you want to copy from a source folder all files at the maximum depth of maxdepth to the current directory. Proceed as follows:

```bash
find ~/mnt/ -maxdepth 4 -type f | while read -r file; do
    rel_path=$(realpath --relative-to="$HOME/mnt" "$file");
    target_dir=$(dirname "$rel_path");
    mkdir -p "$target_dir";
    cp "$file" "$rel_path";
done
```

### Copy the contents of a text file to the clipboard

To copy the contents of a text file to the clipboard using the Linux command line, you can use the `xclip` utility. Once `xclip` is installed, you can copy the contents of a text file to the clipboard using the following command:

```bash
xclip -selection clipboard -i <file>
```

Replace `<file>` with the path to your text file. This command reads the contents of the specified file and copies it to the clipboard using the `-i` option. The `-selection clipboard` option specifies that the clipboard should be used as the target (as opposed to the primary or secondary selections).
