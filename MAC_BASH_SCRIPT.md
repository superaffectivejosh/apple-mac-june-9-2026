# Mac Bash Script

### Created by Josh Stroud

### MacBook Pro 14" with M5 Pro Chip and 24 GB of RAM

### Mac OS Running Mac, Unix, and Python, C++, and Bash

# ==============================================================================
# SECURE, HIGH-PERFORMANCE BASHRC BOOTSTRAP
# ==============================================================================

# 1. SECURITY & SAFETY
# ------------------------------------------------------------------------------
set -o noclobber                 # Prevent overwriting files with '>'
umask 077                        # Set strict default permissions for new files
export TMOUT=600                 # Auto-logout after 10 minutes of inactivity
shopt -s autocd                  # Navigate to directories by just typing their name
shopt -s cdspell                 # Correct minor spelling errors in cd commands

# 2. PERFORMANCE & HISTORY
# ------------------------------------------------------------------------------
export HISTSIZE=50000            # Large history size
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups  # Remove duplicates and don't save redundant commands
shopt -s histappend              # Append to history instead of overwriting
export HISTTIMEFORMAT="[%F %T] "   # Timestamp every command

# 3. HIGH-PERFORMANCE UI & PROMPT
# ------------------------------------------------------------------------------
# 256-color support
export CLICOLOR=1
export LSCOLORS="ExFxBxDxCxegedabagacad"

# Asynchronous, fast PS1 prompt (User@Host in red for root, green for user)
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Construct the prompt dynamically to avoid lag
set_prompts() {
    local LAST_STATUS=$?
    local MAGENTA="\[\033[01;35m\]"
    local CYAN="\[\033[01;36m\]"
    local GREEN="\[\033[00;32m\]"
    local RED="\[\033[00;31m\]"
    local RESET="\[\033[00m\]"

    # Display exit code in red if the last command failed
    local PROMPT_SYMBOL="$"
    if [[ $UID -eq 0 ]]; then
        PROMPT_SYMBOL="#"
    fi

    local STATUS_STR=""
    if [[ $LAST_STATUS -ne 0 ]]; then
        STATUS_STR="${RED}[$LAST_STATUS]${RESET} "
    fi

    export PS1="${STATUS_STR}${CYAN}\u@\h${RESET} ${GREEN}\w${MAGENTA}\$(parse_git_branch)${RESET} ${PROMPT_SYMBOL} "
}
PROMPT_COMMAND=set_prompts

# 4. SECURE ALIASES & PRODUCTIVITY
# ------------------------------------------------------------------------------
alias cp='cp -i'                 # Confirm before overwriting
alias mv='mv -i'
alias rm='rm -I'                 # Confirm once before trashing multiple files
alias ls='ls --color=auto'
alias ll='ls -lhaF'
alias grep='grep --color=auto'

# Shortcut functions to make work faster
mkcd() { mkdir -p "$1" && cd "$1"; } # Create a directory and enter it instantly
cls() { clear; }                     # Fast clear
update() {                           # Safe and unified package updates
    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt upgrade
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf upgrade
    elif command -v brew >/dev/null 2>&1; then
        brew update && brew upgrade
    else
        echo "No supported package manager found."
    fi
}

# 5. ENVIRONMENT VARIABLES
# ------------------------------------------------------------------------------
export EDITOR="nano"                 # Set your preferred CLI text editor
export PATH="$HOME/.local/bin:$PATH" # Ensure local binaries load first

# 6. COMPLETIONS (Fast auto-complete for git/ssh)
# ------------------------------------------------------------------------------
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# ==============================================================================
# END OF BOOTSTRAP
# ==============================================================================

