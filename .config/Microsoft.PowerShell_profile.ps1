# Personal configurations

Invoke-Expression (&starship init powershell)
Enable-TransientPrompt

# PSFzf Config
Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'

Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module posh-git

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS = '
  --height 80%
  --reverse
  --border
'
$env:FZF_CTRL_T_OPTS = '
--preview="bat --style=numbers --color=always {} || cat {}"
--preview-window=right:60%
'

$env:FZF_ALT_C_OPTS = '
--walker-skip .git,node_modules,.pnpm-store,.venv,.uv-cache
--preview "tree -C {}"
'

$env:FZF_DEFAULT_COMMAND = 'fd --type f --exclude .git --exclude node_modules --exclude .pnpm-store --exclude .venv --exclude .uv-cache --strip-cwd-prefix'
$env:FZF_ALT_C_COMMAND = 'fd --type d --exclude .git --exclude node_modules --exclude .pnpm-store --exclude .venv --exclude .uv-cache'
$env:FZF_CTRL_T_COMMAND = "$env:FZF_DEFAULT_COMMAND"

function mkcd {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $Path
  )

  if (Test-Path -Path $Path) {
    if (Test-Path -PathType Container $Path) {
      Write-Host "Directory '$Path' already exists."
      Set-Location -Path $Path
    }
    else {
      Write-Error "Path '$Path' exists but is not a directory."
      return
    }
  }
  else {
    try {
      New-Item -ItemType Directory -Path $Path -Force | Out-Null # -Force creates parent directories
      Set-Location -Path $Path
    }
    catch {
      Write-Error "Error creating directory '$Path': $($_.Exception.Message)"
      return
    }
  }
}

# Bash powered commands via Cygwin
function bzcmp { & "C:\cygwin64\bin\bash.exe" bzcmp @args }
function bzdiff { & "C:\cygwin64\bin\bash.exe" bzdiff @args }
function bzegrep { & "C:\cygwin64\bin\bash.exe" bzegrep @args }
function bzfgrep { & "C:\cygwin64\bin\bash.exe" bzfgrep @args }
function bzgrep { & "C:\cygwin64\bin\bash.exe" bzgrep @args }
function bzless { & "C:\cygwin64\bin\bash.exe" bzless @args }
function bzmore { & "C:\cygwin64\bin\bash.exe" bzmore @args }
function command { & "C:\cygwin64\bin\bash.exe" command -v @args }
function egrep { & "C:\cygwin64\bin\bash.exe" egrep @args }
function fgrep { & "C:\cygwin64\bin\bash.exe" fgrep @args }
function gunzip { & "C:\cygwin64\bin\bash.exe" gunzip @args }
function lzcat { & "C:\cygwin64\bin\bash.exe" lzcat @args }
function lzcmp { & "C:\cygwin64\bin\bash.exe" lzcmp @args }
function lzdiff { & "C:\cygwin64\bin\bash.exe" lzdiff @args }
function lzegrep { & "C:\cygwin64\bin\bash.exe" lzegrep @args }
function lzfgrep { & "C:\cygwin64\bin\bash.exe" lzfgrep @args }
function lzgrep { & "C:\cygwin64\bin\bash.exe" lzgrep @args }
function lzless { & "C:\cygwin64\bin\bash.exe" lzless @args }
function lzma { & "C:\cygwin64\bin\bash.exe" lzma @args }
function lzmore { & "C:\cygwin64\bin\bash.exe" lzmore @args }
function vimdiff { & "C:\cygwin64\bin\bash.exe" vimdiff @args }
function xzcat { & "C:\cygwin64\bin\bash.exe" xzcat @args }
function xzcmp { & "C:\cygwin64\bin\bash.exe" xzcmp @args }
function xzdiff { & "C:\cygwin64\bin\bash.exe" xzdiff @args }
function xzegrep { & "C:\cygwin64\bin\bash.exe" xzegrep @args }
function xzfgrep { & "C:\cygwin64\bin\bash.exe" xzfgrep @args }
function xzgrep { & "C:\cygwin64\bin\bash.exe" xzgrep @args }
function xzless { & "C:\cygwin64\bin\bash.exe" xzless @args }
function xzmore { & "C:\cygwin64\bin\bash.exe" xzmore @args }
function zcat { & "C:\cygwin64\bin\bash.exe" zcat @args }
function zcmp { & "C:\cygwin64\bin\bash.exe" zcmp @args }
function zdiff { & "C:\cygwin64\bin\bash.exe" zdiff @args }
function zegrep { & "C:\cygwin64\bin\bash.exe" zegrep @args }
function zfgrep { & "C:\cygwin64\bin\bash.exe" zfgrep @args }
function zgrep { & "C:\cygwin64\bin\bash.exe" zgrep @args }
function zless { & "C:\cygwin64\bin\bash.exe" zless @args }
function zmore { & "C:\cygwin64\bin\bash.exe" zmore @args }
function znew { & "C:\cygwin64\bin\bash.exe" znew @args }
function zstdcat { & "C:\cygwin64\bin\bash.exe" zstdcat @args }
function zstdgrep { & "C:\cygwin64\bin\bash.exe" zstdgrep @args }
function zstdless { & "C:\cygwin64\bin\bash.exe" zstdless @args }
function zstdmt { & "C:\cygwin64\bin\bash.exe" zstdmt @args }

# Make file operations interactive
function rm { & "C:\cygwin64\bin\rm.exe" -i @args }

# Default to human-readable figures
function du { & "C:\cygwin64\bin\du.exe" -h @args }

# Misc
function grep { & "C:\cygwin64\bin\grep.exe" --color=auto --exclude-dir=`{.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv`} @args }
function less { bat --paging=always @args }

# eza directory listings
function ls {
  param([string[]][Parameter(ValueFromRemainingArguments)] $zrest)

  # Normalize args and expand leading ~ only when it is the first character (~, ~/path, ~\path)
  $argsList = @()
  foreach ($arg in ($zrest ?? @())) {
    if ($arg -match '^~(?=($|[\\/]))') {
      $rest = $arg.Substring(1)
      if ($rest -and ($rest[0] -eq '\' -or $rest[0] -eq '/')) { $rest = $rest.Substring(1) }
      $argsList += if ([string]::IsNullOrEmpty($rest)) { $HOME } else { Join-Path -Path $HOME -ChildPath $rest }
    } else {
      $argsList += $arg
    }
  }

  # If no args, just list current directory
  if ($argsList.Count -eq 0) {
    eza --sort ext --group-directories-first --icons
    return
  }

  # Expand PowerShell wildcards (* ? [ ]) for external tool
  $withWild  = $argsList | Where-Object { $_ -match '[\*\?\[\]]' }
  $noWild    = $argsList | Where-Object { $_ -notmatch '[\*\?\[\]]' }

  $targets = @()
  foreach ($p in $withWild) {
    $matches = Get-ChildItem -Path $p -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
    # Remove $PWD part from $matches
    if ($matches) { $targets += $matches -replace [regex]::Escape($PWD.Path + '\'), '' }
  }
  if ($noWild) { $targets += $noWild }

  if ($targets.Count -gt 0) {
    # IMPORTANT: pass arrays as $targets, not @targets (splat), to avoid char-by-char args
    eza --sort ext --group-directories-first --icons @($targets)
  } else {
    Write-Error ("ls: no matches for pattern(s): {0}" -f ($withWild -join ', '))
  }
}

function ll { param ( [string[]] [Parameter(ValueFromRemainingArguments)] $zrest )
    if ($($zrest.Length) -gt 0) {
        $regular = ($zrest | Where-Object { $_ -notmatch '[*\?]+' })
        $expanded = ($zrest | Where-Object { $_ -match '[*\?]+' } | Get-Item -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
    }
    eza -lAh --sort ext --group-directories-first --icons --hyperlink --git --git-repos $regular $expanded
}

function la { param ( [string[]] [Parameter(ValueFromRemainingArguments)] $zrest )
    if ($($zrest.Length) -gt 0) {
        ls -a @zrest
    } else {
        ls -a
    }
}

function l { param ( [string[]] [Parameter(ValueFromRemainingArguments)] $zrest )
    if ($($zrest.Length) -gt 0) {
        ls -1F @zrest
    } else {
        ls -1F
    }
}

# zsh style aliases
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }

# Helper functions for git aliases
function git_current_branch { git branch --show-current @args }
function git_develop_branch { if (git show-ref --verify --quiet refs/heads/develop) { echo develop } else { echo main } }
function git_main_branch { if (git show-ref --verify --quiet refs/heads/main) { echo main } else { echo master } }


function g { git @args }
function ga { git add @args }
function gaa { git add --all @args }
function gam { git am @args }
function gama { git am --abort @args }
function gamc { git am --continue @args }
function gams { git am --skip @args }
function gamscp { git am --show-current-patch @args }
function gap { git apply @args }
function gapa { git add --patch @args }
function gapt { git apply --3way @args }
function gau { git add --update @args }
function gav { git add --verbose @args }
function gb { git branch @args }
function gbD { git branch --delete --force @args }
function gba { git branch --all @args }
function gbd { git branch --delete @args }
function gbg { LANG=C git branch -vv | grep ": gone\]" @args }
function gbgD { LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '{print $1}' | xargs git branch -D @args }
function gbgd { LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '{print $1}' | xargs git branch -d @args }
function gbl { git blame -w @args }
function gbm { git branch --move @args }
function gbnm { git branch --no-merged @args }
function gbr { git branch --remote @args }
function gbs { git bisect @args }
function gbsb { git bisect bad @args }
function gbsg { git bisect good @args }
function gbsn { git bisect new @args }
function gbso { git bisect old @args }
function gbsr { git bisect reset @args }
function gbss { git bisect start @args }
function gc { git commit --verbose @args }
function gc! { git commit --verbose --amend @args }
function gcB { git checkout -B @args }
function gca { git commit --verbose --all @args }
function gca! { git commit --verbose --all --amend @args }
function gcam { git commit --all --message @args }
function gcan! { git commit --verbose --all --no-edit --amend @args }
function gcann! { git commit --verbose --all --date=now --no-edit --amend @args }
function gcans! { git commit --verbose --all --signoff --no-edit --amend @args }
function gcas { git commit --all --signoff @args }
function gcasm { git commit --all --signoff --message @args }
function gcb { git checkout -b @args }
function gcd { git checkout $(git_develop_branch) @args }
function gcf { git config --list @args }
function gcfu { git commit --fixup @args }
function gcl { git clone --recurse-submodules @args }
function gclean { git clean --interactive -d @args }
function gclf { git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules @args }
function gcm { git checkout $(git_main_branch) @args }
function gcmsg { git commit --message @args }
function gcn { git commit --verbose --no-edit @args }
function gcn! { git commit --verbose --no-edit --amend @args }
function gco { git checkout @args }
function gcor { git checkout --recurse-submodules @args }
function gcount { git shortlog --summary --numbered @args }
function gcp { git cherry-pick @args }
function gcpa { git cherry-pick --abort @args }
function gcpc { git cherry-pick --continue @args }
function gcs { git commit --gpg-sign @args }
function gcsm { git commit --signoff --message @args }
function gcss { git commit --gpg-sign --signoff @args }
function gcssm { git commit --gpg-sign --signoff --message @args }
function gd { git diff @args }
function gdca { git diff --cached @args }
function gdct { git describe --tags $(git rev-list --tags --max-count=1) @args }
function gdcw { git diff --cached --word-diff @args }
function gds { git diff --staged @args }
function gdt { git diff-tree --no-commit-id --name-only -r @args }
function gdup { git diff '@{upstream}' @args }
function gdw { git diff --word-diff @args }
function gf { git fetch @args }
function gfa { git fetch --all --tags --prune --jobs=10 @args }
function gfg { git ls-files | grep @args }
function gfo { git fetch origin @args }
function gg { git gui citool @args }
function gga { git gui citool --amend @args }
function ggpull { git pull origin "$(git_current_branch)" @args }
function ggpur { git pull --rebase @args }
function ggpush { git push origin "$(git_current_branch)" @args }
function ggsup { git branch --set-upstream-to=origin/$(git_current_branch) @args }
function ghh { git help @args }
function gignore { git update-index --assume-unchanged @args }
function gignored { git ls-files -v | grep "^[[:lower:]]" @args }
function gl { git pull @args }
function glg { git log --stat @args }
function glgg { git log --graph @args }
function glgga { git log --graph --decorate --all @args }
function glgm { git log --graph --max-count=10 @args }
function glgp { git log --stat --patch @args }
function glo { git log --oneline --decorate @args }
function glod { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" @args }
function glods { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short @args }
function glog { git log --oneline --decorate --graph @args }
function gloga { git log --oneline --decorate --graph --all @args }
function glol { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" @args }
function glola { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all @args }
function glols { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat @args }
function glp { git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative @args }
function gluc { git pull upstream $(git_current_branch) @args }
function glum { git pull upstream $(git_main_branch) @args }
function gm { git merge @args }
function gma { git merge --abort @args }
function gmc { git merge --continue @args }
function gmff { git merge --ff-only @args }
function gmom { git merge origin/$(git_main_branch) @args }
function gms { git merge --squash @args }
function gmtl { git mergetool --no-prompt @args }
function gmtlvim { git mergetool --no-prompt --tool=vimdiff @args }
function gmum { git merge upstream/$(git_main_branch) @args }
function gp { git push @args }
function gpd { git push --dry-run @args }
function gpf { git push --force-with-lease --force-if-includes @args }
function gpf! { git push --force @args }
function gpoat { git push origin --all && git push origin --tags @args }
function gpod { git push origin --delete @args }
function gpr { git pull --rebase @args }
function gpra { git pull --rebase --autostash @args }
function gprav { git pull --rebase --autostash -v @args }
function gpristine { git reset --hard && git clean --force -dfx @args }
function gprom { git pull --rebase origin $(git_main_branch) @args }
function gpromi { git pull --rebase=interactive origin $(git_main_branch) @args }
function gprum { git pull --rebase upstream $(git_main_branch) @args }
function gprumi { git pull --rebase=interactive upstream $(git_main_branch) @args }
function gprv { git pull --rebase -v @args }
function gpsup { git push --set-upstream origin $(git_current_branch) @args }
function gpsupf { git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes @args }
function gpu { git push upstream @args }
function gpv { git push --verbose @args }
function gr { git remote @args }
function gra { git remote add @args }
function grb { git rebase @args }
function grba { git rebase --abort @args }
function grbc { git rebase --continue @args }
function grbd { git rebase $(git_develop_branch) @args }
function grbi { git rebase --interactive @args }
function grbm { git rebase $(git_main_branch) @args }
function grbo { git rebase --onto @args }
function grbom { git rebase origin/$(git_main_branch) @args }
function grbs { git rebase --skip @args }
function grbum { git rebase upstream/$(git_main_branch) @args }
function grev { git revert @args }
function greva { git revert --abort @args }
function grevc { git revert --continue @args }
function grf { git reflog @args }
function grh { git reset @args }
function grhh { git reset --hard @args }
function grhk { git reset --keep @args }
function grhs { git reset --soft @args }
function grm { git rm @args }
function grmc { git rm --cached @args }
function grmv { git remote rename @args }
function groh { git reset origin/$(git_current_branch) --hard @args }
function grrm { git remote remove @args }
function grs { git restore @args }
function grset { git remote set-url @args }
function grss { git restore --source @args }
function grst { git restore --staged @args }
function grt { cd "$(git rev-parse --show-toplevel || echo .)" @args }
function gru { git reset -- @args }
function grup { git remote update @args }
function grv { git remote --verbose @args }
function gsb { git status --short --branch @args }
function gsd { git svn dcommit @args }
function gsh { git show @args }
function gsi { git submodule init @args }
function gsps { git show --pretty=short --show-signature @args }
function gsr { git svn rebase @args }
function gss { git status --short @args }
function gst { git status @args }
function gsta { git stash push @args }
function gstaa { git stash apply @args }
function gstall { git stash --all @args }
function gstc { git stash clear @args }
function gstd { git stash drop @args }
function gstda { git stash drop --all @args }
function gstl { git stash list @args }
function gstp { git stash pop @args }
function gsts { git stash show --patch @args }
function gstu { gsta --include-untracked @args }
function gsu { git submodule update @args }
function gsw { git switch @args }
function gswc { git switch --create @args }
function gswd { git switch $(git_develop_branch) @args }
function gswm { git switch $(git_main_branch) @args }
function gta { git tag --annotate @args }
function gtl { 
    param([string]$pattern = "*")

    # Get the git tags and sort them
    $tags = git tag --sort=-v:refname -n --list "$pattern*"

    foreach ($tag in $tags) {
        if ($tag -like "*v1*") {
            # Color tags containing "v1" in blue
            Write-Host $tag -ForegroundColor Blue
        } elseif ($tag -like "*alpha*") {
            # Color alpha tags in yellow
            Write-Host $tag -ForegroundColor Yellow
        } else {
            # Default color for all other tags
            Write-Host $tag -ForegroundColor Green
        }
    }
}
function gts { git tag --sign @args }
function gtv { git tag | sort -V @args }
function gunignore { git update-index --no-assume-unchanged @args }
function gunwip { git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1 @args }
function gwch { git whatchanged -p --abbrev-commit --pretty=medium @args }
function gwip { git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]" @args }
function gwipe { git reset --hard && git clean --force -df @args }
function gwt { git worktree @args }
function gwta { git worktree add @args }
function gwtls { git worktree list @args }
function gwtmv { git worktree move @args }
function gwtrm { git worktree remove @args }

# Quick extract archives (tar, zip, etc.)
function x { 
  param([string]$file)
  if ($file -match '\.tar\.gz$') { tar -xvzf $file }
  elseif ($file -match '\.zip$') { unzip $file }
  else { Write-Host "Unknown format: $file" }
}

# Yazi
function y {
  $tmp = [System.IO.Path]::GetTempFileName()
  yazi $args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp -Encoding UTF8
  if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
    Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
  }
  Remove-Item -Path $tmp
}

Remove-Alias -Name echo -Force -ErrorAction SilentlyContinue
Remove-Alias -Name tee -Force -ErrorAction SilentlyContinue
Remove-Alias -Name type -Force -ErrorAction SilentlyContinue
Remove-Alias -Name where -Force -ErrorAction SilentlyContinue
Remove-Alias -Name diff -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name chdir -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name mv -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name rm -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name cp -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name sort -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name cat -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name man -Force -ErrorAction SilentlyContinue
Remove-Alias -Name ls -Force -ErrorAction SilentlyContinue
Set-Alias -Name vim -Value nvim
Set-Alias -Name htop -Value btop
Set-Alias -Name top -Value tasklist
Set-Alias -Name awk -Value gawk
Set-Alias -Name ps -Value procs
Set-Alias -Name df -Value duf
Set-Alias -Name diff -Value delta
Set-Alias -Name wget -Value wget2

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Docker completion
if (Get-Command docker -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (docker completion powershell | Out-String) })
}

# Rustup completion
if (Get-Command rustup -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (rustup completions powershell | Out-String) }) 
}

# pnpm completion
if (Get-Command pnpm -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (pnpm completion pwsh | Out-String) })
}

if (Get-Command rg -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (rg --generate complete-powershell | Out-String) })
}

if (Get-Command uv -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (uv generate-shell-completion powershell | Out-String) })
}

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" } 
