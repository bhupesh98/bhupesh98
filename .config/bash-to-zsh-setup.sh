# Install zsh
sudo apt install zsh

# Change shell to zsh
sudo chsh -s $(which zsh)

# Restart shell
exec zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Edit .zshrc file to use the Powerlevel10k theme
sed -i 's|ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc


git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

git clone --depth=1 https://github.com/hlissner/zsh-autopair.git $ZSH_CUSTOM/plugins/zsh-autopair

# Edit .zshrc file to use the zsh-autopair plugin
sed -i 's/plugins=(.*)/plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-autopair)/' ~/.zshrc

# Install necessary dev tool dependency
sudo apt install fzf fd-find ripgrep bat

echo "
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
# FZF default options (colors, layout, etc.)
export FZF_DEFAULT_OPTS='
  --height 80%
  --layout=reverse
  --border
'
export FZF_CTRL_T_OPTS='
--preview=\"bat --style=numbers --color=always {} || cat {}\"
--preview-window=right:60%
'
# Optional: Use fd (if installed) for faster file search
export FZF_DEFAULT_COMMAND='fd --type f --exclude \".git\" --exclude \"node_modules\" --exclude \".venv\" --exclude \"venv\"'
export FZF_CTRL_T_COMMAND=\"\$FZF_DEFAULT_COMMAND\"
" >> ~/.zshrc

source ~/.zshrc
