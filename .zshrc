# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export PATH="/home/bhudgens/.local/bin:$PATH"

git () {
    [ "${1}" = "push" ] && [ "$#" -lt 2 ] && echo "Use 'git push \$remote \$branch'" && return
    /usr/bin/git "$@"
}

# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)
# Temporarily disabled to test latency: zsh-syntax-highlighting

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
#  $bitwarden_id<space>$friendly_name_on_your_disk
# Example:
#  23423423423432423 my_key
export KEYME_KEYS_TO_LOAD="
6828649b-46b1-4a84-88d9-adbe00ca8ce1 id_rsa
d9aaf5f5-38f6-453f-af7f-b3f100d79beb netbird-virginia-key
0c915de4-2cee-40a2-bf3b-b3f100d7a3de netbird-exit-east-key
bf080775-98de-4667-9922-b3f100d7aa89 netbird-exit-west-key
159a7ff9-71d4-4549-9643-b3f100bc90d9 openclaw
43e3530b-1d28-4288-bd7f-b4000006e04e agent1_id_ed25519
c2b2853d-df9b-4ed3-bb95-b4000006ec53 agent2_id_ed25519
ca2268e6-5298-46a3-a757-b4000006f7ed agent3_id_ed25519
1850e8ea-1270-4429-9b22-b40000070343 agent4_id_ed25519
18aac40d-c093-4253-a49a-b40000070e72 agent5_id_ed25519
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

alias assume='source assume'

# opencode
export PATH=/home/bhudgens/.opencode/bin:$PATH

