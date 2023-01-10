$VerbosePreference = 'Continue'
# Correcting verbose color
$Host.PrivateData.VerboseForegroundColor = 'Cyan'

$CurrPath = $PSScriptRoot
$ModuleVersion = Split-Path -Path $CurrPath -leaf
$ModuleName = Split-Path -Path $(Split-Path -Path $CurrPath) -leaf
Remove-Module -Name $ModuleName -Verbose:$False -ErrorAction SilentlyContinue
Import-Module -Name $ModuleName -MinimumVersion $ModuleVersion -Verbose:$False
Set-StrictMode -Version 'Latest'
