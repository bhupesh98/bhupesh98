#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Installs all dependencies required for the PowerShell profile configuration.

.DESCRIPTION
    This script installs all the tools, modules, and applications needed to run
    the PowerShell profile configuration correctly. It includes PowerShell modules,
    CLI tools, and applications from various sources.

.EXAMPLE
    .\Install-PowerShellDependencies.ps1
    .\Install-PowerShellDependencies.ps1 -SkipWinget -SkipPowerShellModules -SkipCygwin
    
.NOTES
    This script requires Administrator privileges to install some components.
    Some installations may require system restart or shell restart to take effect.
#>

param(
    [switch]$SkipWinget,
    [switch]$SkipPowerShellModules,
    [switch]$SkipCygwin,
    [switch]$Verbose
)

# Set error action preference
$ErrorActionPreference = "Continue"

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check if command exists
function Test-CommandExists {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Function to install PowerShell modules
function Install-PowerShellModules {
    Write-ColorOutput "Installing PowerShell modules..." "Cyan"
    
    $modules = @(
        'PSFzf',
        'posh-git',
        'Microsoft.WinGet.CommandNotFound',
        'PSReadLine'
    )
    
    foreach ($module in $modules) {
        try {
            if (Get-Module -ListAvailable -Name $module) {
                Write-ColorOutput "✓ Module $module is already installed" "Green"
            } else {
                Write-ColorOutput "Installing module: $module" "Yellow"
                Install-Module -Name $module -Force -AllowClobber -Scope CurrentUser
                Write-ColorOutput "✓ Successfully installed $module" "Green"
            }
        }
        catch {
            Write-ColorOutput "✗ Failed to install module $module`: $($_.Exception.Message)" "Red"
        }
    }
}

# Function to install applications via winget
function Install-WingetApplications {
    Write-ColorOutput "Installing applications via winget..." "Cyan"
    
    # Check if winget is available
    if (-not (Test-CommandExists "winget")) {
        Write-ColorOutput "✗ winget is not available. Please install App Installer from Microsoft Store." "Red"
        return
    }
    
    $applications = @(
        @{Name = "fzf"; Id = "junegunn.fzf"},
        @{Name = "fd"; Id = "sharkdp.fd"},
        @{Name = "bat"; Id = "sharkdp.bat"},
        @{Name = "eza"; Id = "eza-community.eza"},
        @{Name = "yazi"; Id = "sxyazi.yazi"},
        @{Name = "neovim"; Id = "Neovim.Neovim"},
        @{Name = "btop"; Id = "aristocratos.btop4win"},
        @{Name = "procs"; Id = "dalance.procs"},
        @{Name = "duf"; Id = "muesli.duf"},
        @{Name = "delta"; Id = "dandavison.delta"},
        @{Name = "gitui"; Id = "StephanDilly.gitui"},
        @{Name = "oh-my-posh"; Id = "JanDeDobbeleer.OhMyPosh"},
        @{Name = "zoxide"; Id = "ajeetdsouza.zoxide"},
        @{Name = "docker"; Id = "Docker.DockerDesktop"},
        @{Name = "wget"; Id = "GNU.Wget2"},
        @{Name = "git"; Id = "Git.MinGit"},
        @{Name = "gh"; Id = "GitHub.cli"},
        @{Name = "git-lfs"; Id = "GitHub.GitLFS"},
        @{Name = "nodejs"; Id = "OpenJS.NodeJS.LTS"},
        @{Name = "powertoys"; Id = "Microsoft.PowerToys"},
        @{Name = "ast-grep"; Id = "ast-grep.ast-grep"}
    )
    
    foreach ($app in $applications) {
        try {
            Write-ColorOutput "Checking if $($app.Name) is installed..." "Yellow"
            $result = winget list --id $app.Id --exact 2>$null
            if ($LASTEXITCODE -eq 0 -and $result -match $app.Id) {
                Write-ColorOutput "✓ $($app.Name) is already installed" "Green"
            } else {
                Write-ColorOutput "Installing $($app.Name)..." "Yellow"
                winget install --id $app.Id --exact --silent --accept-package-agreements --accept-source-agreements
                if ($LASTEXITCODE -eq 0) {
                    Write-ColorOutput "✓ Successfully installed $($app.Name)" "Green"
                } else {
                    Write-ColorOutput "✗ Failed to install $($app.Name)" "Red"
                }
            }
        }
        catch {
            Write-ColorOutput "✗ Error installing $($app.Name)`: $($_.Exception.Message)" "Red"
        }
    }
}

# Function to install Cygwin
function Install-Cygwin {
    Write-ColorOutput "Installing Cygwin..." "Cyan"
    
    if (Test-Path "C:\cygwin64\bin\bash.exe") {
        Write-ColorOutput "✓ Cygwin is already installed" "Green"
        return
    }
    
    try {
        $cygwinSetup = "$env:TEMP\setup-x86_64.exe"
        Write-ColorOutput "Downloading Cygwin installer..." "Yellow"
        Invoke-WebRequest -Uri "https://www.cygwin.com/setup-x86_64.exe" -OutFile $cygwinSetup
        
        Write-ColorOutput "Installing Cygwin..." "Yellow"
        Start-Process -FilePath $cygwinSetup -ArgumentList @(
            "--quiet-mode",
            "--download",
            "--local-install",
            "--no-verify",
            "--root", "C:\cygwin64",
            "--local-package-dir", "$env:TEMP\cygwin-packages",
            "--packages", "apt-cyg,gzip,bzip2,xz,zstd,grep,less,coreutils,util-linux"
        ) -Wait
        
        Write-ColorOutput "✓ Cygwin installation completed" "Green"
        
        # Install apt-cyg for easier package management
        if (Test-Path "C:\cygwin64\bin\bash.exe") {
            Write-ColorOutput "Installing apt-cyg..." "Yellow"
            $aptCygScript = @"
curl -fsSL https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg > /bin/apt-cyg
chmod +x /bin/apt-cyg
"@
            $aptCygScript | & "C:\cygwin64\bin\bash.exe" -l
            Write-ColorOutput "✓ apt-cyg installed" "Green"
        }
    }
    catch {
        Write-ColorOutput "✗ Failed to install Cygwin: $($_.Exception.Message)" "Red"
    }
    finally {
        if (Test-Path $cygwinSetup) {
            Remove-Item $cygwinSetup -Force
        }
    }
}

# Function to update PATH environment variable
function Update-PathEnvironment {
    Write-ColorOutput "Updating PATH environment variable..." "Cyan"
    
    $pathsToAdd = @(
        "C:\cygwin64\bin"
    )
    
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $pathUpdated = $false
    
    foreach ($path in $pathsToAdd) {
        if ($currentPath -notlike "*$path*") {
            Write-ColorOutput "Adding $path to PATH..." "Yellow"
            $currentPath = "$currentPath;$path"
            $pathUpdated = $true
        } else {
            Write-ColorOutput "✓ $path is already in PATH" "Green"
        }
    }
    
    if ($pathUpdated) {
        try {
            [Environment]::SetEnvironmentVariable("PATH", $currentPath, "Machine")
            Write-ColorOutput "✓ PATH updated successfully" "Green"
            Write-ColorOutput "Note: You may need to restart your shell or system for PATH changes to take effect." "Yellow"
        }
        catch {
            Write-ColorOutput "✗ Failed to update PATH: $($_.Exception.Message)" "Red"
        }
    }
}

# Function to verify installations
function Test-Installations {
    Write-ColorOutput "`nVerifying installations..." "Cyan"
    
    $commands = @(
        "fzf", "fd", "bat", "eza", "git", "yazi", "nvim", 
        "btop", "gawk", "procs", "duf", "delta", "oh-my-posh", 
        "zoxide", "docker", "gh", "node", "gitui"
    )
    
    $successful = 0
    $failed = 0
    
    foreach ($cmd in $commands) {
        if (Test-CommandExists $cmd) {
            Write-ColorOutput "✓ $cmd is available" "Green"
            $successful++
        } else {
            Write-ColorOutput "✗ $cmd is not available" "Red"
            $failed++
        }
    }
    
    Write-ColorOutput "`nInstallation Summary:" "Cyan"
    Write-ColorOutput "✓ Successful: $successful" "Green"
    Write-ColorOutput "✗ Failed: $failed" "Red"
    
    if ($failed -gt 0) {
        Write-ColorOutput "`nSome installations failed. You may need to:" "Yellow"
        Write-ColorOutput "- Restart your PowerShell session" "Yellow"
        Write-ColorOutput "- Restart your computer" "Yellow"
        Write-ColorOutput "- Manually install failed components" "Yellow"
        Write-ColorOutput "- Check your PATH environment variable" "Yellow"
    }
}

# Main installation function
function Start-Installation {
    if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "Installing PowerShell v7..." "Cyan"
        Invoke-WebRequest -Uri "https://aka.ms/install-powershell.ps1" -OutFile "install-powershell.ps1"
        .\install-powershell.ps1 -UseMSI
        Remove-Item "install-powershell.ps1"
    } else {
        Write-ColorOutput "✓ PowerShell v7 is already installed" "Green"
    }
    Write-ColorOutput "Starting PowerShell profile dependencies installation..." "Cyan"
    Write-ColorOutput "This may take several minutes depending on your internet connection." "Yellow"
    Write-ColorOutput ""


    if (-not $SkipPowerShellModules) {
        Install-PowerShellModules
        Write-ColorOutput ""
    }
    
    if (-not $SkipWinget) {
        Install-WingetApplications
        Write-ColorOutput ""
    }
    
    if (-not $SkipCygwin) {
        Install-Cygwin
        Write-ColorOutput ""
    }
    
    Update-PathEnvironment
    Write-ColorOutput ""
    
    Test-Installations
    
    Write-ColorOutput "`nInstallation completed!" "Green"
    Write-ColorOutput "Please restart your PowerShell session for all changes to take effect." "Yellow"
    Write-ColorOutput "You may also need to restart your computer for some PATH changes." "Yellow"
    Write-ColorOutput "[TIP] Use the command:" "Yellow" -NoNewline
    Write-ColorOutput "winget upgrade --all" "Magenta" -NoNewline
    Write-ColorOutput " to update installed applications via winget." "Yellow"
}

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-ColorOutput "This script requires Administrator privileges." "Red"
    Write-ColorOutput "Please run PowerShell as Administrator and try again." "Yellow"
    exit 1
}

# Start the installation
Start-Installation
