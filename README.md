# Githooks

## Summary

GitHooks provides a multi-hook framework for Git Hooks, along with a collection of scripts for the purposes of encouraging a commit policy, altering the project environment depending on the state of the repository, and implementing continuous integration workflows. The framework allows multi-script execution,  you can use GitHooks to automate or optimize virtually any aspect of your development workflow. 
 
## Getting Started

Git Hooks are event-based scripts you can place in a hooks directory to trigger actions at certain points in git’s execution. When you run certain git commands, the software will run the associated script within the git repository. GitHooks extends on this by enabling the installation of any arbitrary number of hooks for a command.

## Installation

You can install hooks in a git repository by two methods: unzipping then deleting, or manually copying in the scripts. Either option you will need to use the command line to setup your git repository, however it is recommended to use the unzip method as it is less likely to encounter mistakes (forgetting to set execution bit, missing a script, etc).

### Unzip githooks

You can quickly install a set of hooks into the git repository by unzipping `githooks.zip` into the `.git/hooks/` directory. To install all hooks and sub-hooks, you can do so with the following:

```bash
unzip githooks.zip -d .git/hooks/
chmod +x .git/hooks/*
```

You can then delete any hooks from the `.git/hooks/` directory that you do not wish to use.

### Manual Copying

To manually install a git hook, you will need to start by copying the hook into the `.git/hooks/` directory. The git hook, also known as the entrypoint hook, is responsible for executing scripts in a sub-directory. If you wish to install the `commit-msg` hook, you can do the following:

```bash
cp commit-msg .git/hooks/commit-msg
mkdir -p .git/hooks/commit-msg.d/
chmod +x .git/hooks/commit-msg
```

After copying in the entrypoint hook, you will be able to copy hooks into a sub-directory named after the hook (e.g. `commit-msg.d/`). These hooks will be run by the entrypoint hook, `commit-msg`. To add a hook, you can do so with the following:

```bash
cp 001-my-githook.sh .git/hooks/commit-msg.d/
```

This will install the hook `001-my-githook.sh` into the `commit-msg.d/` directory. When the entrypoint `commit-msg` is executed, it will call any scripts in the `commit-msg.d/` directory. The entrypoint hook can be of the form of any supported git hook (`applypatch-msg`, `commit-msg`, `post-update`, `pre-applypatch`, `pre-commit`, etc). 

## Build

You can build the project using the scripts available in the [`build/`](build/) directory. The `lint.sh` script will work to ensure that the scripts are compliant with the `/bin/sh` shell, enabling it to work on most git environments. You can do this with the following:

```bash
sh build/lint.sh
```

Or you can use the docker based script, `docker-lint.sh` if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh build/docker-lint.sh
```

### Packaging

You can package the git hooks into a single archive using the `package.sh` script. You can do this with the following:

```bash
sh build/package.sh
```

You can use the packaged hooks to quickly install the hooks into a git repository. The packaged hooks are available under `out/githooks*.zip`.

## Tests

All scripts in the repository use [Bash Automated Testing System (Bats)](https://github.com/sstephenson/bats) for testing. All scripts have tests associated with them in the `tests/` directory. These scripts are responsible for verifying the execution behaviour of any of the hooks in the repository. To run all the tests in the `tests/` directory, you can do this with the following:

```bash
sh run.sh
```

Or you can use the docker based script, `docker-run.sh` if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh docker-run.sh
```