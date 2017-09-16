# Githooks

## Summary

Git Hooks are scripts you can place in a hooks directory to trigger actions at certain points in git’s execution. To enable a hook script, put a script in the hooks subdirectory of your Git directory (`.git/hooks/<hook>.d/`) that is named appropriately and is executable. From that point forward, it will be called the entrypoint hook.

Common use cases for Git hooks include encouraging a commit policy, altering the project environment depending on the state of the repository, and implementing continuous integration workflows. But, since scripts are infinitely customizable, you can use Git hooks to automate or optimize virtually any aspect of your development workflow.

## Getting Started

You can install the hooks in a git repository through two methods: unzipping then deleting, or manually copying in the scripts. Either option you will need to use the command line to setup your git repository, however it is recommended to use the unzip method as it is less likely to encounter mistakes (forgetting to set execution bit, missing a script, etc).

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

|Name|Description|
|---|---|