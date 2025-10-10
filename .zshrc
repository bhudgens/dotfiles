# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export PATH="/home/bhudgens/.local/bin:$PATH"

git () {
    [ "${1}" = "push" ] && [ "$#" -lt 2 ] && echo "Don't DO IT!!!" && return
    /usr/bin/git "$@"
}

# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

DISABLE_MAGIC_FUNCTIONS=true
source $ZSH/oh-my-zsh.sh

setopt share_history
HISTSIZE=10000000000
SAVEHIST=10000000000

autoload compinit
compinit
autoload bashcompinit
bashcompinit

npm config set save-prefix ''

source ${HOME}/.benvironment

export DEFAULT_USER=benjamin
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    # Original - but we just want the host
    # prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
    prompt_segment black default "%(!.%{%F{yellow}%}.)%m"
  fi
}

# Which keys you want to load when you run 'keyme'
# Syntax:
#  $last_pass_id<space>$friendly_name_on_your_disk
# Example:
#  23423423423432423 my_key
export KEYME_KEYS_TO_LOAD="
6828649b-46b1-4a84-88d9-adbe00ca8ce1 id_rsa
"
export LASTPASS_USER="benjamin@benjamindavid.com"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if which glgroup > /dev/null; then
  source <(glgroup bashcomplete)
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

which kubectl > /dev/null && source <(kubectl completion zsh)

export LPASS_DISABLE_PINENTRY=1

alias luamake=/tmp/lua-language-server/3rd/luamake/luamake

alias assume="source assume"
