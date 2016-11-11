#!/usr/bin/env bash

powerline() {
  # Unicode symbols
  # Symbols http://unicode-table.com/en/
  readonly PS_ARROW='➡'
  readonly GIT_BRANCH_SYMBOL='⎇  '
  readonly GIT_BRANCH_CHANGED_SYMBOL='+'
  readonly GIT_NEED_PUSH_SYMBOL='↑'
  readonly GIT_NEED_PULL_SYMBOL='↓'

  # Colors
  readonly FG_RED="\[$(tput setaf 1)\]"
  readonly FG_GREEN="\[$(tput setaf 2)\]"
  readonly BG_RED="\[$(tput setab 1)\]"
  readonly BG_GREEN="\[$(tput setab 2)\]"
  readonly FG_DARKRED="\[$(tput setaf 9)\]"
  readonly FG_BLUE="\[$(tput setaf 4)\]"
  readonly FG_LIGHT_BLUE="\[$(tput setaf 6)\]"
  readonly FG_LIGHT_GREEN="\[$(tput setaf 10)\]"
  
  readonly DIM="\[$(tput dim)\]"
  readonly REVERSE="\[$(tput rev)\]"
  readonly RESET="\[$(tput sgr0)\]"
  readonly BOLD="\[$(tput bold)\]"
  
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
    local aheadN="$(echo "$stat" | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    local behindN="$(echo "$stat" | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
    [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
    [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"
  
    # Check if the brach is local only
    local local_repo="$($git_eng remote)"
    [ -z "$local_repo" ] && no_remote="L "

    # print the git branch segment without a trailing newline
    echo "($no_remote$GIT_BRANCH_SYMBOL$branch$marks) "
  }

  ps1() {
    # Check the exit code of the previous command and display different
    # colors in the prompt accordingly.
    # must be first in this function to work
    if [ $? -eq 0 ]; then
      local fg_exit="$FG_GREEN"
    else
      local fg_exit="$FG_RED"
    fi

    # Set the colors for ps1 segments
    # @ 
    local fg_et="$FG_DARKRED"
    # host
    local fg_host="$FG_LIGHT_GREEN"
    # path
    local fg_path="$FG_DARKRED"
    # git
    local fg_git="$FG_LIGHT_BLUE"
    # arrow symbol
    local ps_symbol="$PS_ARROW"

    # Check if the user is root and set the starting section color
    if [ "$(whoami)" == "root" ] ; then
      local fg_user="$BOLD$FG_RED"
    else
      local fg_user="$BOLD$FG_LIGHT_GREEN"
    fi
    
    # Get Virtual Env (python virtualenv)
    if [[ $VIRTUAL_ENV != "" ]] ; then
      # Strip out the path and just leave the env name
      venv="$FG_BLUE(${VIRTUAL_ENV##*/}) "
    else
      # In case you don't have one activated
      venv=''
    fi

    # Base with the start and the delimiter
    # Username and host
    PS1="$fg_user\u$fg_et@$fg_host\h $RESET"
    # Path section
    PS1+="$fg_path\w $RESET"
    # Git section
    PS1+="$fg_git$(git_info)$RESET"
    # Python virtualenv section
    PS1+="$venv$RESET"
    # Ending section
    PS1+="$fg_exit$ps_symbol$RESET "
  }
  PROMPT_COMMAND=ps1
}

powerline
unset powerline
