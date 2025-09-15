#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Opens or creates a directory in the ServiceNow folder and displays it in File Explorer.

.DESCRIPTION
    This script accepts a directory name as a command line parameter. It checks if the directory
    exists in the ServiceNow base path (C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow).
    If the directory exists, it opens it in a new File Explorer tab. If it doesn't exist,
    the script creates the directory first and then opens it. If File Explorer is not running,
    it will be launched automatically.

.PARAMETER DirectoryName
    The name of the directory to open or create. This parameter is mandatory.

.PARAMETER Help
    Shows this help information.

.EXAMPLE
    .\Open-ServiceNowDirectory.ps1 "Project1"
    Opens or creates the directory "Project1" in the ServiceNow folder.

.EXAMPLE
    .\Open-ServiceNowDirectory.ps1 -DirectoryName "New Project"
    Opens or creates the directory "New Project" in the ServiceNow folder.

.EXAMPLE
    .\Open-ServiceNowDirectory.ps1 -Help
    Displays help information for this script.

.NOTES
    Author: Created for ServiceNow directory management
    Version: 1.0
    Created: 2025
    
    Requirements:
    - Windows 11
    - PowerShell 5.1 or later
    - Access to the specified OneDrive path
#>

param(
    [Parameter(Mandatory=$false, Position=0, HelpMessage="Enter the directory name to open or create")]
    [string]$DirectoryName,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Display help if requested or if no parameters provided
if ($Help -or [string]::IsNullOrWhiteSpace($DirectoryName)) {
    Get-Help $MyInvocation.MyCommand.Path -Full
    exit 0
}

# Configuration
$BaseDirectory = "C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow"

# Function to write colored output
function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check if File Explorer is running
function Test-FileExplorerRunning {
    try {
        $explorerProcesses = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
        return ($explorerProcesses.Count -gt 0)
    }
    catch {
        return $false
    }
}

# Function to open directory in File Explorer
function Open-DirectoryInExplorer {
    param([string]$Path)
    
    try {
        # Use explorer.exe to open the directory
        # The /select parameter would select a file, but we want to open the folder
        Start-Process -FilePath "explorer.exe" -ArgumentList "`"$Path`"" -ErrorAction Stop
        Write-ColoredOutput "✓ Opened directory in File Explorer: $Path" -Color "Green"
        return $true
    }
    catch {
        Write-ColoredOutput "✗ Failed to open directory in File Explorer: $($_.Exception.Message)" -Color "Red"
        return $false
    }
}

# Main script execution
try {
    Write-ColoredOutput "ServiceNow Directory Manager" -Color "Cyan"
    Write-ColoredOutput "================================" -Color "Cyan"
    
    # Validate and sanitize directory name
    if ([string]::IsNullOrWhiteSpace($DirectoryName)) {
        throw "Directory name cannot be empty or whitespace only."
    }
    
    # Remove invalid characters from directory name
    $InvalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    $CleanDirectoryName = $DirectoryName
    foreach ($InvalidChar in $InvalidChars) {
        $CleanDirectoryName = $CleanDirectoryName.Replace($InvalidChar, '')
    }
    
    if ($CleanDirectoryName -ne $DirectoryName) {
        Write-ColoredOutput "⚠ Cleaned directory name from '$DirectoryName' to '$CleanDirectoryName'" -Color "Yellow"
    }
    
    if ([string]::IsNullOrWhiteSpace($CleanDirectoryName)) {
        throw "Directory name contains only invalid characters."
    }
    
    # Construct full path
    $FullPath = Join-Path -Path $BaseDirectory -ChildPath $CleanDirectoryName
    
    Write-ColoredOutput "Target directory: $FullPath" -Color "Gray"
    
    # Check if base directory exists
    if (-not (Test-Path -Path $BaseDirectory -PathType Container)) {
        Write-ColoredOutput "✗ Base directory does not exist: $BaseDirectory" -Color "Red"
        Write-ColoredOutput "Please ensure OneDrive is properly synced and the path is correct." -Color "Yellow"
        exit 1
    }
    
    # Check if target directory exists
    if (Test-Path -Path $FullPath -PathType Container) {
        Write-ColoredOutput "✓ Directory already exists: $CleanDirectoryName" -Color "Green"
    }
    else {
        Write-ColoredOutput "Directory does not exist. Creating: $CleanDirectoryName" -Color "Yellow"
        
        try {
            New-Item -Path $FullPath -ItemType Directory -Force | Out-Null
            Write-ColoredOutput "✓ Successfully created directory: $CleanDirectoryName" -Color "Green"
        }
        catch {
            Write-ColoredOutput "✗ Failed to create directory: $($_.Exception.Message)" -Color "Red"
            exit 1
        }
    }
    
    # Check if File Explorer is running
    if (-not (Test-FileExplorerRunning)) {
        Write-ColoredOutput "File Explorer is not running. It will be started automatically." -Color "Yellow"
    }
    
    # Open directory in File Explorer
    if (Open-DirectoryInExplorer -Path $FullPath) {
        Write-ColoredOutput "✓ Operation completed successfully!" -Color "Green"
    }
    else {
        Write-ColoredOutput "✗ Failed to open directory in File Explorer" -Color "Red"
        exit 1
    }
}
catch {
    Write-ColoredOutput "✗ Error: $($_.Exception.Message)" -Color "Red"
    Write-ColoredOutput "Stack Trace: $($_.ScriptStackTrace)" -Color "DarkRed"
    exit 1
}

# End of script