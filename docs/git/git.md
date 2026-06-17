# Git

This repository includes a reusable Git configuration focused on a predictable, clean, and efficient daily workflow.

The versioned configuration is stored in:

~~~text
configs/git/.gitconfig
~~~

Personal identity, credentials, signing keys, and account-specific settings must remain in the user's global Git configuration and must not be committed.

## Installation

Include the versioned configuration from the global Git configuration:

~~~bash
git config --global include.path \
  "$HOME/Documents/Projects/mac-dev-setup/configs/git/.gitconfig"
~~~

Verify the include:

~~~bash
git config --global --get include.path
~~~

## Default branch

New repositories use `main` as their initial branch:

~~~ini
[init]
    defaultBranch = main
~~~

## Fetch and pull behavior

Deleted remote branches are pruned automatically during fetch operations:

~~~ini
[fetch]
    prune = true
~~~

Pull operations use rebase instead of creating an automatic merge commit:

~~~ini
[pull]
    rebase = true
~~~

Local changes are temporarily stashed and restored during rebases:

~~~ini
[rebase]
    autoStash = true
~~~

## Push behavior

The first push of a new branch automatically creates its upstream tracking branch:

~~~ini
[push]
    autoSetupRemote = true
~~~

## Conflict resolution

Git remembers previous conflict resolutions:

~~~ini
[rerere]
    enabled = true
    autoupdate = true
~~~

Previously recorded resolutions may be reapplied and staged automatically.

Merge conflicts use the `zdiff3` style:

~~~ini
[merge]
    conflictStyle = zdiff3
~~~

## Branch and tag display

Branches are sorted by most recent commit date:

~~~ini
[branch]
    sort = -committerdate
~~~

Tags are sorted using version-aware ordering:

~~~ini
[tag]
    sort = version:refname
~~~

Lists use columns when appropriate:

~~~ini
[column]
    ui = auto
~~~

## Command assistance

Git prompts before applying a suggested correction for a mistyped command:

~~~ini
[help]
    autocorrect = prompt
~~~

## Diff and commit display

Moved lines are highlighted more clearly in diffs:

~~~ini
[diff]
    colorMoved = zebra
~~~

Interactive commits display the diff below the commit message editor:

~~~ini
[commit]
    verbose = true
~~~

Git Delta is configured separately in the same file and provides the default pager and enhanced diff rendering.

## Validation

Validate the configuration syntax:

~~~bash
git config --file configs/git/.gitconfig --list >/dev/null \
  && echo "Git configuration is valid."
~~~

Inspect the effective configuration:

~~~bash
git config --global --includes --list --show-origin
~~~

Inspect only the workflow-related settings:

~~~bash
git config --global --includes --get-regexp \
  '^(init\.|fetch\.|pull\.|rebase\.|push\.|rerere\.|branch\.|tag\.|column\.|help\.|diff\.|commit\.|merge\.|core\.|interactive\.|delta\.)'
~~~

## Rollback

Remove the include from the global Git configuration:

~~~bash
git config --global --fixed-value --unset-all include.path \
  "$HOME/Documents/Projects/mac-dev-setup/configs/git/.gitconfig"
~~~

Review the global configuration afterward:

~~~bash
git config --global --list --show-origin
~~~

Removing the include disables the versioned settings without deleting personal identity or credential configuration.
