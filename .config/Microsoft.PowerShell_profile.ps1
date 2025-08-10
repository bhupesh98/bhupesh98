# Personal configurations

# PSFzf Config
Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'

#Set-PSReadLineKeyHandler -Key Tab -Function TabCompleteNext | sed -e 's/^\.\\//' -e 's/\\/\//g'
#Set-PSReadLineKeyHandler -Key Shift+Tab -Function TabCompletePrevious | sed -e 's/^\.\\//' -e 's/\\/\//g'

Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module posh-git


Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS='
  --height 80%
  --reverse
  --border
'
$env:FZF_CTRL_T_OPTS = '
--preview="bat --style=numbers --color=always {} || cat {}"
--preview-window=right:60%
'

$env:FZF_DEFAULT_COMMAND='fd --type f --exclude .git --exclude node_modules --exclude .pnpm-store --exclude .venv --exclude venv'
$env:FZF_ALT_C_COMMAND = 'fd --type d --exclude .git --exclude node_modules --exclude .pnpm-store --exclude .venv --exclude venv'
$env:FZF_CTRL_T_COMMAND="$env:FZF_DEFAULT_COMMAND"

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
    } else {
        Write-Error "Path '$Path' exists but is not a directory."
        return
    }
  } else {
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

function gunzip {    
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )
    
    $version = @"
gunzip (gzip) 1.10
Copyright (C) 2007, 2011-2018 Free Software Foundation, Inc.
This is free software.  You may redistribute copies of it under the terms of
the GNU General Public License <https://www.gnu.org/licenses/gpl.html>.
There is NO WARRANTY, to the extent permitted by law.
Written by Paul Eggert.
"@

    $usage = @"
Usage: Gunzip [OPTION]... [FILE]...
Uncompress FILEs (by default, in-place).
Mandatory arguments to long options are mandatory for short options too.
  -c, --stdout      write on standard output, keep original files unchanged
  -f, --force       force overwrite of output file and compress links
  -k, --keep        keep (don't delete) input files
  -l, --list        list compressed file contents
  -n, --no-name     do not save or restore the original name and timestamp
  -N, --name        save or restore the original name and timestamp
  -q, --quiet       suppress all warnings
  -r, --recursive   operate recursively on directories
  -S, --suffix=SUF  use suffix SUF on compressed files
      --synchronous synchronous output (safer if system crashes, but slower)
  -t, --test        test compressed file integrity
  -v, --verbose     verbose mode
      --help        display this help and exit
  -V, --version     display version information and exit
With no FILE, or when FILE is -, read standard input.
Report bugs to <bug-gzip@gnu.org>.
"@

    if ($Arguments -and $Arguments.Count -gt 0) {
        $firstArg = $Arguments[0]

        if ($firstArg -eq "--help") {
            Write-Output $usage
            return
        }

        if ($firstArg -eq "--version" -or $firstArg -eq "-V") {
            Write-Output $version
            return
        }
    }
    
    # If not handling help or version, pass all arguments directly to gzip -d
    try {
        & gzip -d $Arguments
    } catch {
        Write-Error "Failed to execute gzip: $_"
    }
}

function apt-cyg { & "C:\cygwin64\bin\bash.exe" apt-cyg @args}

function ConvertTo-CygwinPath {
    param (
        [string]$Path
    )
    # Check if cygpath exists and if the path needs conversion
    if ($Path -match '^[A-Za-z]:[\\/]' -or $Path -match '^[A-Za-z]:$') { # Checks for drive letters
        & "C:\cygwin64\bin\cygpath.exe" -u "$Path"
    } else {
        return $Path # Return original path if it's already Cygwin-like or a relative path not needing conversion
    }
}

# Wrap Cygwin rm
function rm {
    param(
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\rm.exe" -i $convertedPaths
}

# Wrap Cygwin df (doesn't usually take paths, but good practice to include path conversion)
function df {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$ArgsList
    )
    $convertedArgs = $ArgsList | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\df.exe" -h $convertedArgs
}

# Wrap Cygwin du (takes paths)
function du {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\du.exe" -h $convertedPaths
}

# Misc functions
function less {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$ArgsList
    )
    $convertedArgs = $ArgsList | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\less.exe" -r $convertedArgs
}

function grep {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$ArgsList
    )
    $convertedArgs = $ArgsList | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\grep.exe" --color=auto $convertedArgs
}

# Directory listing functions (ls, ll, la, l)
function ls {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\ls.exe" -hF --color=auto $convertedPaths
}

function ll {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\ls.exe" -hF --color=auto -l $convertedPaths
}

function la {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\ls.exe" -hF --color=auto -A $convertedPaths
}

function l {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]$Paths
    )
    $convertedPaths = $Paths | ForEach-Object { ConvertTo-CygwinPath -Path $_ }
    & "C:\cygwin64\bin\ls.exe" -CF --color=auto $convertedPaths
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

Remove-Alias -Name where -Force -ErrorAction SilentlyContinue
Remove-Alias -Name diff -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name chdir -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name mv -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name rm -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name cp -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name sort -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name cat -Force -ErrorAction SilentlyContinue 
Remove-Alias -Name man -Force -ErrorAction SilentlyContinue
Set-Alias -Name vim -Value nvim
Set-Alias -Name htop -Value btop
Set-Alias -Name top -Value tasklist
Set-Alias -Name awk -Value gawk

$ompInit = oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\lightgreen.omp.json"
Invoke-Expression $ompInit

Enable-PoshTransientPrompt

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
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Docker completion
Invoke-Expression (& { (docker completion powershell | Out-String) })

# kubectl completion
Invoke-Expression (& { (kubectl completion powershell | Out-String) })

# pnpm completion
Invoke-Expression (& { (pnpm completion pwsh | Out-String) })

# gh completion
Invoke-Expression (& { (gh completion -s powershell | Out-String) })

# minikube completion
Invoke-Expression (& { (minikube completion powershell | Out-String) })

# helm completion
Invoke-Expression (& { (helm completion powershell | Out-String) })
