---
title: Version Control and Backups
description: Fundamentals of Git, version control workflows, and backup strategies from the OCF Linux SysAdmin DeCal.
author: Sawan Srivastava
date: 2026-09-07T23:06:00-07:00
draft: false
toc: false
tags:
  - git
  - foss
---

This post explores the fundamentals of version control systems and backup strategies as covered in Lecture 8 of the OCF Linux SysAdmin DeCal. Understanding these concepts is crucial for any developer or system administrator looking to maintain code integrity and data safety.

---

## Why Version Control?

Version Control Systems (VCS) are essential tools in modern software development for several key reasons:

- **Track changes:** Monitor modifications to code over time.
- **Collaboration:** Work with others without worrying too much about conflicting changes.
- **Safe experimentation:** Create and test features without breaking production code.

Examples of VCS include Git, Mercurial, Subversion, Perforce, and Bazaar. Git has become the modern-day standard, and it's important to note: **Git is not GitHub!** Git is the version control system itself, while GitHub is a cloud-based hosting service for Git repositories. Github has its own CLI that works alongside git (gh).

### About Git

Git is a free and open-source system created by Linus Torvalds in 2005 for development of the Linux kernel. After their previous proprietary VCS (Bitkeeper) withdrew the free version, Torvalds built the first implementation in just 2-3 months.

Fun fact: "Git" is also British slang meaning "unpleasant person." Torvalds has said: *"I'm an egotistical bastard, and I name all my projects after myself. First 'Linux', now 'Git'."*

---

## What Makes Git Special?

### Git Stores Snapshots

Git stores snapshots (versions) of files and directory structure, keeping track of relationships, authors, dates, and log messages.

### Git Has Integrity

Git hashes objects with SHA1, making it impossible to change anything without Git knowing. This protects against:

- Lost information in transit
- File corruption

### Git is Very Fast

Nearly every operation is local with no network latency overhead. Browsing project history involves Git reading directly from your local database. This means you can work offline.

### Distributed Architecture

There can be many copies of a given repository, each supporting independent development, with machinery to transmit and reconcile versions between repositories.

---

## Git Internals

Git represents project history as a **directed acyclic graph (DAG)** of commit nodes. Nodes point one-way to the state they're based on, and there are no cycles.

### Key Components

- **Commits:** Correspond to project state's tree (snapshots).
- **Blobs:** Files stored as "blobs" of bits.
- **Trees:** Folders containing blobs and/or other trees.
- **Branches:** Pointers to the head of a line of work. Default name is `master` or `main`.
- **HEAD:** A pointer to the local branch you're currently on.

---

## File States in Git

Understanding file states is crucial for working with Git:

### Modified

File is changed but isn't committed to your database (repository) yet. You can see which files are modified with `git status`.

### Staged

Modified file is marked in its current version to be included in the next commit snapshot. (commonly done with the `git add` command)

### Tracked vs. Untracked

- **Tracked files:** Files git knows about (from last snapshot + newly staged files). Can be unmodified, modified, or staged.
- **Untracked files:** Everything else. Use `.gitignore` to specify intentionally untracked files to ignore.

Tip: If you accidentally added a file to github that you didn't want tracked, you can use `git rm --cached` to untrack it.

---

## Getting Started with Git

### Creating a Repository

For an existing project in directory `proj/`:

    cd proj/
    git init

This creates a new subdirectory `.git` making `proj/` a Git repository.

### Cloning an Existing Repository

    git clone <repo URL> [destination]

This creates a directory, initializes a `.git` directory inside it, and pulls down all data from the repository.

    git clone https://github.com/0xcf/decal-labs

---

## Branching: Git's Killer Feature

Branching is what sets Git apart from other version control systems. The idea is to create a new 'branch' with the current branch as the 'trunk'. This creates a new pointer at the same location as HEAD. Every time you commit, the pointer of the active branch moves forward automatically.

### Basic Branch Commands

- `git branch <name>`: Create a new branch
- `git switch <name>`: Switch to a branch
- `git switch -c <name>`: Create and switch to a new branch
- `git branch -d <name>`: Delete a branch

(legacy command was git checkout)

---

## Merging

The idea is to combine a branch back into the mainline/trunk with a merge commit. For example, if you have branch `iss53` (issue \#53) and are ready to merge it into the main codebase:

    git switch master
    git merge iss53
    git branch -d iss53

This changes HEAD to point to master, creates a merge commit combining both branches, and deletes the branch `iss53`.

### Merge Conflicts

If the same part of the same file is different in the two branches you're merging, Git won't be able to merge them cleanly and will throw a merge conflict. Files with conflicts will go unmerged, and Git adds conflict-resolution markers:

    <<<<<<< HEAD
    [Lines of code from HEAD (i.e master)]
    =======
    [Lines of code from the merge target (i.e iss53)]
    >>>>>>> [Commit message]

Use `git status` to see which files conflict, edit them to resolve conflicts, then `git add` each file to mark it as resolved, and `git commit` to finalize the merge.

---

## Rebasing

The idea is to take all commits from a branch and apply them on top of HEAD with no merge commit, as if you just made all the commits on the main branch anyways (linear history).

    git switch experiment
    git rebase master
    git switch master
    git merge experiment

**Note:** Rebase re-writes history. Best used in private branches.

---

## Working with Remotes

The remote is the offsite copy of the repository. `origin` is the default name for a remote when you run `git clone`. Remote branch names take the form `<remote>/<branch>`.

Before you make your first commit, git will tell you to add your name and email as the "author" of the commit. To make changes to repos on github however, you will need to authenticate your github account with `gh auth login`. 

### Essential Remote Commands

- `git remote -v`: View all remotes and their URLs
- `git remote show <remote>`: Show information about a remote
- `git fetch <remote>`: Fetch new data from remote and update local database without modifying working directory
- `git pull [remote/branch]`: Equivalent to `git fetch && git merge`
- `git push <remote> <branch>`: Push local commits to remote/branch

**Good practice:** Pull before you push to avoid conflicts.

---

## The Git Workflow

Here's a typical workflow for working with Git:

    git switch master
    git switch -b feature
    [Modify files]
    git add file-changed-1 [...] file-changed-n
    git commit -m "description of changes"
    git push origin feature
    git switch master
    git pull origin master
    git merge feature
    git push origin master

If you find yourself comfortable with this workflow and want to expand your git repertoire, look into git worktrees.

---

## Backups: Just Do It

According to Murphy's law: "Anything that can go wrong will go wrong." You need backups to protect against:

- Accidental or malicious deletion
- Device failure
- Software failure
- Theft

**Important considerations:**

- Automate backups because you will forget
- Don't leak information! Backups must be secure
- Make sure your backups actually work by routinely testing backup and recovery procedures

Github is a great way to do this! Look into Github Actions!

---

## The 3-2-1 Rule

Follow this simple rule to ensure data safety:

- **3:** Have at least 3 copies of your data
- **2:** Store your data on at least 2 different media (e.g., 1 hard drive, 1 backup server)
- **1:** Have at least 1 copy of your data off-site (e.g., on Amazon S3, "the cloud")

---

## The GitLab Database Outage: A Cautionary Tale

On January 31, 2017, GitLab suffered a major database outage that serves as an important lesson on the importance of backups.

### What Happened

An engineer accidentally ran `rm -rf` on their production PostgreSQL database. They noticed and stopped it after 1 second, but 300GB of production data was lost. This shouldn't have been catastrophic—they could just recover from a backup, right?

### Backup 1: Amazon S3

GitLab had an automated process to upload a backup to Amazon S3 every 24 hours. However, their backups had been failing for weeks due to a version mismatch, and their notification system was broken too.

### Backup 2: Azure Disk Snapshots

GitLab had enabled Azure disk snapshots to run every 24 hours... except on the database servers, because they thought they had enough backups.

### Hail Mary: LVM Snapshots

LVM (Logical Volume Manager) snapshots weren't meant to be a backup, but luckily they had these. An engineer had run the copy from prod to staging ~6 hours before the incident. Unfortunately, it took GitLab 18 hours to recover since staging was not meant for data recovery (different region and slow disks).

### Impact

GitLab estimated they lost at least 5,000 projects, 5,000 comments, and roughly 700 users. The incident became both a feel-good story of transparency and not firing the engineer involved, but also a cautionary tale about backup failures.

**The lesson:** The importance of keeping backups, making sure they work, and practicing recovering from them.

---

## Tools for Backups

### rsync

Simple command-line utility for local ↔ remote transfer. Skips copying files that are the same at the destination, making it ideal for backups. Uses SSH for transferring to remote hosts.

    rsync -av -P [source] user@host:[destination]

The `-a` flag enables archive mode (recursion and preserve file permissions).

### rclone

Described as "rsync for cloud storage," rclone supports every major cloud storage provider and can mount cloud storage as a local filesystem.

    rclone sync source:path dest:path

---

## Additional Resources

- **Pro Git** (git-scm.com) — The bible for Git. Chapters 1-5 form a good foundation.
- **Oh Shit, Git!?!** (ohshitgit.com) — "Git is hard: screwing up is easy, and figuring out how to fix your mistakes is fucking impossible." Short guide on how to recover from common Git mistakes.
- **Shell/Editor integration** — Tools like vim-fugitive can enhance your Git workflow.
