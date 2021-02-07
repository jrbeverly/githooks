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

## Hooks

### Hook: commit-msg

The `commit-msg` hook takes a path to a temporary file that contais the commit message. If this script exits non-zero, Git aborts the commit process. The following hooks are designed to prevent mistakes or encourage better practices.

|Name|Description|
|---|---|
|checkjira.empty|A hook responsible for automatically populating a commit message when the message is empty.|
|extendjira.issue|A hook responsible for substituting the jira issue id in place of a constant when on a feature branch.|
|extendjira.ref|A hook responsible for substituting a jira issue reference in place of a constant when on a feature branch.|
|checkjira.enforcekey|A hook responsible for enforcing that feature branch jira issue exists in the commit when on a feature branch.|
|checkjira.matchkey|A hook responsible for verifying that a jira issue exists in the commit when on a feature branch.|

### Hook: pre-push

The `pre-push` hook runs during git push, after the remote refs have been updated but before any objects have been transferred. If this script exits non-zero, Git aborts the commit process. The following hooks are designed to prevent mistakes or encourage better practices.

## Acknowledgements

The project icon is by [Mario Gallego Adán from the Noun Project](docs/icon/README.md).
