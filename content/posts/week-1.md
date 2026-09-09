---
title: Intro to Linux and FOSS
description: Shell, kernel, Linux, licenses, and FOSS
author: Carl Luo
date: 2026-09-07T23:06:00-07:00
draft: false
toc: false
tags:
  - linux
  - foss
---
## The Shell 
The shell is a command line-interface (CLI) for interactint with the computer.

It is perhaps one of the most important parts of a Unix system. For the system, many important tasks run through shell scripts, which are text files containing a sequence of shell commands. For the user, the shell is how you talk to the computer.

Some common shells: `bash`, `zsh`, `fish` (the `sh` stands for shell). The bash shell is usually the default on a Linux system.

> If you don't know if you're using zsh or bash, run `echo $0`

Basic command structure: `[commands] [flags] [arguments]`

```bash
$ ls -a ~/ 

ls # lists the contents of a directory
-a # do not ignore hidden entries (entries starting with .)
~/ # your home directory
```

## Common shell commands

### `cat`
One of the easiest Unix commands to understand, it simply outputs the contents of one or more files. 
```bash
$ cat file1 file2 ...
```

### `cd`
Stands for **change directory**. It changes current working directory into another directory. You'll use it pretty much constantly when navigating around the filesystem.

```bash
$ pwd # print working directory
/home/carl

$ cd ocf
$ pwd 
/home/carl/ocf
```

If you omit which directory you're `cd`ing into, it returns to your *home directory*, the directory you started at when you log in.

### `ls` 
Stands for **list**. It lists the contents of a directory. You will use this a lot if you don't already. 

Helpful flags:
- `-l` detailed (long) listing
- `-a` all listings (do not ignore entries starting with .)
- `-A` almost all. `-a` but ignores the default `.` (current directory) and `..` (parent directory)
- `-d` lists the directory itself 
- `-t` sorted by time, descending by default
- `-S` sorted by size
- `-r` reverses the sorting order

### `rm`
Stands for **remove**. It deletes files. 

You need `rm -r` (recursive) to delete directories and their contents, otherwise you're only able to delete empty directories. `rm `-f` forces removal without prompting in situations where `rm` would usually complain. 

```bash
$ rm hi.txt # byebye
```

Be careful with `rm`! It can delete huge portions of your filesystem with no easy way to undo it. `rm -rf /` is an infamous example that will wipe your hard drive. 

### `others`
- `cp` - copy a file to another location, under another name. 
- `mv` - move, works exactly like `cp` but for moving instaed of copying. Very useful for renaming files 
- `touch` - creates a file
- `head` - read the first 10 lines of a file 
- `less` - read larger files
- `mkdir` - make directory
- `pwd` - print working directory 
- `sort` - quickly puts the lines of a text file in alphanumeric order
- `file` - tells you a LOT about a file 
- `grep`, `find`, `locate` - locating files, and texts inside of files. Very powerful commands!
- `echo` - Prints all its arguments to standard output. Very useful for chaining commands

**Shell Globbing**: the shell can match simple patterns against file and directory names, a process known as globbing. The glob character `*` tells the shell to match any number of arbitrary characters. `*at` expands to all filenames ending with at and `at*` expands to all filenames starting. `*at*` expands to all filenames containing at.

**Piping and Redirection**: Ways to chain commands together. `>` (redirection) sends output to a file, and `|` (piping) sends outputs to another command. `>>` to append the output to the file instead of overwriting it.
```bash
$ touch files_list.txt # creates the file 

$ ls -l > files_list.txt # saves the output of ls -l

$ cat names.txt | sort # reads the contents of names.txt, immediately sorts it, and outputs the names in sorted order

$ echo "Adaptive circuits engaged" >> files_list.txt # appends this line to our previous file
```

**Home and Root**: `~` is your home directory, and stores all your user data. Something like `/home/carl` on my end. It's where your Downloads, Documents, Desktop folders are if you use MacOS. `/` is your root directory and is the absolute base of the system, including external hard drives, system files, and all the user data. Don't confuse `/` with `/root`, the former is your root directory, and the latter is the home directory of the **root** user.

## Text Editors
The big three are Vim, Nano, and Emacs. Pick one that appeals the most to you. 
![Relevant](https://cdn.discordapp.com/attachments/936027131752894504/1546795066314457168/xkcd.png?ex=6aa114a9&is=6a9fc329&hm=645a7c8bac85b9710bbdcedcd2fc53843295799e6e6a4b5fdc772de1e17a9e7a)

## GNU/Linux

GNU stands for "GNU is not unix". The GNU project was started by Richard Stallman in 1983 with the goal of developing a completely free, Unix-like system (we'll elaborate more on this in a second).

Eventually, the GNU userland was combined with Linus Torvald's quaint little creation called the Linux kernel to form a stable OS, producing the systems that we commonly think of as Linux distributions today.

![Richard Stallman](https://i.ytimg.com/vi/jUibaPTXSHk/sddefault.jpg)

Strictly, Linux is just the kernel, the part of the OS that talks to hardware, manages memory, and schedules processes. What you actually install is a *Linux distribution*, which typically consists of the kernel, a userland, a package manager, and a collection of default software and configuration. 

![Kernel Diagram](https://www.linuxdoc.org/LDP/sag/overview-kernel.gif)

This is why many argue that Linux should really be called **GNU/Linux**. Most of the basic command line utilities and functionalities we learn and people interact with everyday are from the GNU project. Linux was also unable to run POSIX applications, and it took the incorporation of GNU for that. Some even argue that we should refer to Linux as the kernel, and the actual Operating System is GNU. 

> In a nutshell, what happened was, the FSF started developing GNU by writing things like compilers, C libraries, and basic command line utilities before the kernel. Linus Torvalds, started Linux by writing the Linux kernel first and using applications written for GNU.

This whole argument really depends on how you define Operating Systems as a concept. In common usage, "Linux" is generally used to refer to the entire family of operating systems built around the Linux kernel.

Perhaps the best way to think about GNU is as an extensive collection of free software that can be used as an operating system.

Some important pieces of GNU includes:
- GNU core utilities (`coreutils`), tools like `ls`, `cp`, `mv`, `chmod`, `cat`, `grep`... 
- GNU Debugger (GDB)
- GNU Compiler Collection (GCC)
- GNU Bash shell (`bash`)

You can see just how important the GNU Project has been to software engineering from this alone.

## History of Unix

![Map of Unix](https://blog.jaysa.net/assets/history-of-unix.svg)

In the beginning, there **Unix**, an operating system created at AT&T's Bell Labs.

Unix introduced many ideas that became fundamental to operating systems and software development, including but not limited to:
- Sockets for networking, which are ubiquitous these days
- The philosophy that "everything is a file"

They couldn't really commercialize it, due to legal and regulatory reasons (they were considered a telecom monoply back in the mid 1900s), so AT&T mostly licensed the source code to universities. 

Eventually, the os forked into two major lineages:
1. **System V**. AT&T's lineage, pretty much all closed source, built internally in AT&T. Became increasingly commercial and proprietary as time passed.
2. **BSD**. BSD stands for **berkeley software distribution**!!! Developed at the *University of California, Berkeley*. students built upon the original Unix. It was never really a standalone OS at first, moreso a patch set you applied on top of an AT&T Unix you licensed. this becomes important later.

And they lived in harmony! Until everything changed...

The 1984 AT&T breakup removed many of the restrictions that had limited AT&T's involvement in the computer industry. AT&T began commercializing Unix aggresively, and every vendor began building its own variant tied to its own hardware, each adding proprietary extensions to differentiate itself and to become the "One True Unix". Within a few years Unix meant a dozen mutually incompatible systems that shared ancestry and not much else. this was known as the **Unix Wars**. 

Further reading https://www.usenix.org/system/files/login/articles/login_apr15_17_salus.pdf

This is also where POSIX came into play, it was essentially a standard to ensure a good amount of programs and scripts can run on your os regardless of which unix derivation you went with.

One particular release during that time from AT&T was **System V Release 4 (SVR4)**. They incorporated technology from System V, BSD, and other derivations like SunOS and Xenix into a single unified base. These days, almost every commercially used Unix descends from SVR4! 

Since Berkeley's code was merged with AT&T's, BSD could only be used by existing AT&T licenses. Thus there was an effort to rewrite the OS, and **386BSD** was released in 1992, a completely free Unix.

Because of this, AT&T sued Berkeley in 1992 (and lost!). Berkeley then sued back as during the creation of SVR4, AT&T incorporated BSD code into svr4 without honoring the license. AT&T lost again. hoorah! However, the case dragged long enough that BSD was overtaken by linux in popularity and ubiquity. 

BSD still exists today in the form of OpenBSD, FreeBSD, and **MacOS**! 

Linux is Unix-like but not technically Unix, as it was written completely from scratch (as he wasn't allowed to see AT&T source).

Some commands to inspect your system.
```bash
uname -srm # kernel name, release, machine
cat /etc/os-release # which distro this actually is
```

## Free and Open Source Software (FOSS)

### Free software
"Free software" is primarily an ethical position, associated with Richard Stallman and the Free Software Foundation. 

> Free as in freedom, not as in beer.

The idea is that users should have control over the software they use, not merely the ability to download it for free.

One important concept in free software is **copyleft**. Derivative works must carry the same license. Freedom is protected downstream.

#### The Four Freedoms 
1. The freedom to run the program as you wish, for any purpose
2. The freedom to study how the program works, and change it so it does your computing as you wish. Access to the source code is a precondition for this.
3. The freedom to redistribute copies so you can help others.
3. The freedom to redistribute copies of your modified version to others. By doing this you can give the whole community a chance to benefit from your changes. Access to the source code is a precondition for this.

*[What is free software?](https://www.gnu.org/philosophy/free-sw.html) by the Free Software Foundation*

### Open Source Software 
"Open source" emerged as a rebranding of the free software movement, because "free" sounded scary to corporations, and the ethical framing of the Free Software Movement also didn't bode well to them I suppose.

The Open Source Initiative had a more pragmatic pitch, they emphasized practical benefits of making the source available, where more eyes on the code allows you to find bugs faster, and a distributed development process enables better code. 

This framing enabled more adoption of Linux and open source software as a whole, especially in the corporate world. Optics are important!

You can probably tell that there is significant overlap between the two concepts, but they aren't quite the same philosophical movement. In particular, they diverge on the copyleft question. The free software philosophy views it as an ethical requirement to protect user freedom, while open source software treats it as one of many licenses. 

## Licences
You might have seen this weird file in someone else's repo...

https://github.com/wurtylex/cslib/blob/main/LICENSE

Or, you might have been prompted to choose a license when you made a new github directory.

Licenses are legal agreements that defines how someone else is allowed to use the software in question.

**Copyleft** (GPL). Modifications must stay open.

> Linux is a cancer that attaches itself in an intellectual property sense to everything it touches. 
>
> \- *Steve Ballmer, Former CEO at Microsoft*

**Permissive** (MIT, BSD, Apache): Do whatever you want (basically). Including making it proprietary! 

Jaysa, previous OCF SM & GM and who taught this lecture in the past, wrote about licenses in greater detail here https://blog.jaysa.net/2025/09/09/intro-to-linux-and-foss/#licenses.
