---
layout: post
title: C, C++ and C# playground
tags: programming c c++ c#
---
These are several tips and tricks collected from the web, during my first steps towards a better understanding of the `C`, `C++` and `C#` programming languages.

# Generate a shared library from a C program 

To generate a shared library you need first to compile your `C` code with the `-fPIC` (position independent code) flag.

```bash
gcc -c -fPIC hello.c -o hello.o
```

This will generate an object file `(.o)`, now you take it and create the `.so` file:

```bash
gcc hello.o -shared -o libhello.so
```

To do it in one step you can use

```bash
gcc -shared -o libhello.so -fPIC hello.c
```

You could add `-Wall` to get all warnings, and `-g` to get debugging information, to your gcc commands.

[Source](http://bit.ly/2LQzg3S)

# How to call a C function from C#

Create a `C` file, say `libtest.c` with some content (e.g. a simple pseudo-wrapper for `printf`):

```c
#include <stdio.h>

void print(const char *message)
{
  printf("%s\n", message);
}
```

Then create the shared library `libtest.so`. Finally use your library in `C#`:

```c#
using System;

using System.Runtime.InteropServices;

public class Tester
{
        [DllImport("libtest.so", EntryPoint="print")]

        static extern void print(string message);

        public static void Main(string[] args)
        {

                print("Hello World C# => C++");
        }
}
```

In case of a `System.DllNotFoundException` just add the current directory to the library path:

```bash
export LD_LIBRARY_PATH=pwd
```

[Source](http://bit.ly/2PfLkh3)
