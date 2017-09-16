# Githooks

## Summary

Git Hooks are scripts you can place in a hooks directory to trigger actions at certain points in git’s execution. To enable a hook script, put a script in the hooks subdirectory of your Git directory (`.git/hooks/<hook>.d/`) that is named appropriately and is executable. From that point forward, it will be called the entrypoint hook.

Common use cases for Git hooks include encouraging a commit policy, altering the project environment depending on the state of the repository, and implementing continuous integration workflows. But, since scripts are infinitely customizable, you can use Git hooks to automate or optimize virtually any aspect of your development workflow.

## Installation

You can install the hooks in a git repository through two methods:

### Unzip githooks.zip

You can manually install a hook by installing all the hooks from this directory, then deleting the scripts you are not interested in. To install all hooks, you can do so with the following:

```bash
unzip githooks.zip -d .git/hooks/
chmod +x .git/hooks/*
```

You can then delete any hooks from the `.git/hooks/` directory that you do not wish to use.

### Manual Copying

You can manually install a hook by installing the entrypoint hook. The entrypoint hook (such as `commit-msg`) is responsible for executing any of the scripts in the hook directory (such as `commit-msg.d/`). You can the following to install an entrypoint hook:

```bash
cp commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

The entrypoint hook can be of the form of any supported git hook (`applypatch-msg`, `commit-msg`, `post-update`, `pre-applypatch`, `pre-commit`, etc). To install a hook, you can do so with the following:

```bash
mkdir -p .git/hooks/commit-msg.d/
cp 001-my-githook.sh .git/hooks/commit-msg.d/001-my-githook.sh
```

This will install the hook `001-my-githook.sh` into the `commit-msg.d/` directory. When the entrypoint `commit-msg` is executed, it will call any scripts in `commit-msg.d/`.

## Build

You can build the project using the scripts available in the [`build/`](build/) directory. The `lint.sh` script will work to ensure that the scripts are compliant with the `sh` shell, enabling it to work on most git environments. You can run lint using the following:

```bash
sh build/lint.sh
```

Or you can use the docker based script, `docker-lint.sh` if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh build/docker-lint.sh
```

### Packaging

You can package up the scripts for installing into a git repository using:

```bash
sh build/package.sh
```

The packaged hooks are available under `out/githooks*.zip`, suffixed with the version number.

## Tests

All scripts in the repository use [Bash Automated Testing System (Bats)](https://github.com/sstephenson/bats) for testing. All scripts have unit tests associated with them in the `tests/` directory. These scripts are responsible for verifying the execution behaviour of any of the hooks in the repositroy. You can run the unit tests with the `run.sh` script in the `tests/` directory.

```bash
sh run.sh
```

Or you can use the docker based script, `docker-run.sh` (`docker-run.sh`) if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh docker-run.sh
```