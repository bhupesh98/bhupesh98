######## Uncomment if zsh is not installed ###########################
######################################################################
# Install zsh
# sudo apt install zsh -y

# # Change shell to zsh
# sudo chsh -s $(which zsh)

# # Restart shell
# exec zsh
######################################################################

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone --depth=1 https://github.com/hlissner/zsh-autopair.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autopair

# Edit .zshrc file
sed -i 's|ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
sed -i '1i # Set up brew\neval "$(brew shellenv)"' ~/.zshrc
sed -i "/^[^#]*plugins=/s/plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autopair)\n\n# Set up brew\neval \"\$(brew shellenv)\"\n/" ~/.zshrc

# Install necessary dev tool dependency
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sudo brew install bat fd fzf jq ripgrep yazi zoxide font-symbols-only-nerd-font

echo "
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

# Setup zoxide
eval \"\$(zoxide init zsh)\"
# Setup fzf
source <(fzf --zsh)
# Setup yazi
function y() {
	local tmp=\"\$(mktemp -t \"yazi-cwd.XXXXXX\")\" cwd
	yazi \"\$@\" --cwd-file=\"\$tmp\"
	IFS= read -r -d '' cwd < \"\$tmp\"
	[ -n \"\$cwd\" ] && [ \"\$cwd\" != \"\$PWD\" ] && builtin cd -- \"\$cwd\"
	rm -f -- \"\$tmp\"
}
" >> ~/.zshrc

echo "alias python=python3
" >> ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/alias.zsh

source ~/.zshrc
