# dotfiles

My personal dotfiles

## Installation

Create a file `~/config/mice` with your mice found in `xinput --list`

```shell
sudo --preserve-env=HOME,USER bash install.sh 2>&1 | tee install.log
```
