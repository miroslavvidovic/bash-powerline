# Info

Informative prompt in pure Bash script. 
![](https://github.com/miroslavvidovic/bash-powerline/screenshots/bash-prompt1.png)

## Features

* Prompt style: display "➡" symbol instead of "$"
* Git branch: display "⎇ " symbol and current git branch name, or short SHA1 hash when the head is detached
* Git branch: display "+" symbol when current branch is changed but uncommited
* Git branch: display "↑" symbol and the difference in the number of commits when the current branch is ahead of remote (see screenshot)
* Git branch: display "↓" symbol and the difference in the number of commits when the current branch is behind of remote (see screenshot)
* Display "L" for local repositories
* Color code for the previously failed command
* Display different color for the root user 
* Fast execution (no noticable delay)

## Installation

Download the Bash script

And source it in your `.bashrc`

    source ~/.bash-powerline.sh

## See also
* [powerline](https://github.com/Lokaltog/powerline): Unified Powerline
  written in Python. This is the future of all Powerline derivatives. 
* [vim-powerline](https://github.com/Lokaltog/vim-powerline): Powerline in Vim
  writtien in pure Vimscript. Deprecated.
* [tmux-powerline](https://github.com/erikw/tmux-powerline): Powerline for Tmux
  written in Bash script. Deprecated.
* [powerline-shell](https://github.com/milkbikis/powerline-shell): Powerline for
  Bash/Zsh/Fish implemented in Python. Might be merged into the unified
  Powerline. 
