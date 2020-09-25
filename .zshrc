# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

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

source $ZSH/oh-my-zsh.sh

autoload compinit
compinit
autoload bashcompinit
bashcompinit

npm config set save-prefix ''

source ${HOME}/.benvironment

export DEFAULT_USER=bhudgens
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
4318807893850238648 glguser
5866756601936395183 githubdevopsuser
5251408404796459452 id_rsa
1175375113105532471 devship
8409250839622491492 devdb
4649381101600854493 ops
"
export LASTPASS_USER="bhudgens@glgroup.com"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if which glgroup > /dev/null; then
  source <(glgroup bashcomplete)
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
