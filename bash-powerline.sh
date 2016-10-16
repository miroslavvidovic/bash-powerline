#!/usr/bin/env bash

powerline() {
  # Unicode symbols
  # Symbols http://unicode-table.com/en/
  readonly PS_DELIMITER=''
  readonly PS_STAR='★'
  readonly PS_SUDO='⦿'
  readonly PS_SYMBOL_LINUX='$'
  readonly GIT_BRANCH_SYMBOL='⎇  '
  readonly GIT_BRANCH_CHANGED_SYMBOL='+'
  readonly GIT_NEED_PUSH_SYMBOL='⇡'
  readonly GIT_NEED_PULL_SYMBOL='⇣'
  
  # Colors
  # For colors check a 256 terminal colors cheat sheet
  readonly BG_VIOLET="\[$(tput setab 91)\]"
  readonly FG_VIOLET="\[$(tput setaf 91)\]"
  readonly FG_WHITE="\[$(tput setaf 255)\]"
  readonly FG_GREY="\[$(tput setaf 240)\]"
  readonly BG_GREY="\[$(tput setab 240)\]"
  
  readonly FG_RED="\[$(tput setaf 1)\]"
  readonly FG_GREEN="\[$(tput setaf 2)\]"
  readonly BG_RED="\[$(tput setab 1)\]"
  readonly BG_GREEN="\[$(tput setab 2)\]"
  
  readonly DIM="\[$(tput dim)\]"
  readonly REVERSE="\[$(tput rev)\]"
  readonly RESET="\[$(tput sgr0)\]"
  readonly BOLD="\[$(tput bold)\]"
  
  readonly PS_SYMBOL=$PS_SYMBOL_LINUX

  git_info() {
    [ -x "$(which git)" ] || return    # git not found
    # force git output in English to make our work easier
    local git_eng="env LANG=C git"
    # get current branch name or short SHA1 hash for detached head
    local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
    [ -n "$branch" ] || return  # git branch not found
  
    local marks
  
    # branch is modified?
    [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"
  
    # how many commits local branch is ahead/behind of remote?
    local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
    local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
    [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"
  
    # print the git branch segment without a trailing newline
    printf " $GIT_BRANCH_SYMBOL$branch$marks "
  }

  ps1() {
    # Check the exit code of the previous command and display different
    # colors in the prompt accordingly.
    # must be first in this function to work
    if [ $? -eq 0 ]; then
      local BG_EXIT="$BG_GREEN"
      local FG_EXIT="$FG_GREEN"
    else
      local BG_EXIT="$BG_RED"
      local FG_EXIT="$FG_RED"
    fi

    # Set the colors for ps1 segments
    local fg_base="$FG_WHITE"
    local bg_path="$BG_GREY"
    local fg_path="$FG_WHITE"
    local bg_git="$BG_VIOLET"
    local fg_git="$FG_WHITE"

    # Check if the user is root
    if [ "$(whoami)" == "root" ] ; then
      local PS_USER="$PS_SUDO"
      local bg_base="$BG_RED"
      local delimit="$FG_RED"
    else
      local PS_USER="$PS_STAR"
      local bg_base="$BG_VIOLET"
      local delimit="$FG_VIOLET"
    fi
    
    # Base with the start and the delimiter
    PS1="$bg_base$fg_base $PS_USER $bg_path$delimit$PS_DELIMITER $RESET"
    # Path section
    PS1+="$bg_path$fg_path\W $RESET"
    # Git section
    PS1+="$bg_git$fg_git$(git_info)$RESET"
    # Ending section
    PS1+="$BG_EXIT$fg_base $PS_SYMBOL $RESET$FG_EXIT$PS_DELIMITER$RESET "
  }

  PROMPT_COMMAND=ps1
}

powerline
unset powerline
