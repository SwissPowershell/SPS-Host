<#
    .SYNOPSIS
        This script file helps reload a module and test its internal functions.
    .DESCRIPTION
        This script file helps reload a module and test its internal functions.
    .INPUTS
        None.
    .OUTPUTS
        None.
    .LINK
        https://github.com/SwissPowershell/PowershellHelpers/tree/main/DebugModule.ps1
#>

# Import the module based on the current directory
$ModuleVersion = Split-Path -Path $PSScriptRoot -Leaf
$ModuleName = Split-Path -Path $(Split-Path -Path $PSScriptRoot) -Leaf
$ModuleDefinitionFile = Get-ChildItem -Path $PSScriptRoot -Filter '*.psd1'

# Remove the module (if loaded)
if (Get-Module -Name $ModuleName -ErrorAction Ignore) {try {Remove-Module -Name $ModuleName} catch {Write-Warning "Unable to remove module: $($_.Exception.Message)"}Write-Warning 'The script cannot continue...';break}
# Add the module using the definition file
try {Import-Module $ModuleDefinitionFile.FullName -ErrorAction Stop} catch {Write-Warning "Unable to load the module: $($_.Exception.Message)";Write-Warning 'The script cannot continue...';break}
# Control that the module added is in the same version as the detected version
$Module = Get-Module -Name $ModuleName -ErrorAction Ignore
if ($Module.Version -ne $ModuleVersion) {Write-Warning 'The module version loaded does not match the folder version: please review!';Write-Warning 'The script cannot continue...';break}
# List all the exposed functions from the module
Write-Host 'Module [' -ForegroundColor Yellow -NoNewline;Write-Host $ModuleName -NoNewline -ForegroundColor Magenta;Write-Host '] Version [' -ForegroundColor Yellow -NoNewline;Write-Host $ModuleVersion -NoNewline -ForegroundColor Magenta;Write-Host '] : Loaded !' -ForegroundColor Green
if ($Module.ExportedCommands.Count -gt 0) {Write-Host 'Module''s exposed commands:' -ForegroundColor Yellow;$Module.ExportedCommands.Keys | ForEach-Object {Write-Host "`t - $_" -ForegroundColor Magenta}} else {Write-Host "`t !! There are no exported commands in this module !!" -ForegroundColor Red}
Write-Host '';Write-Host '------------------ Starting script ------------------' -ForegroundColor Yellow
$DebugStart = Get-Date

############################
# Test your functions here #
############################

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# $VerbosePreference = 'Continue'
Write-Line "Hello [World]" -DefaultColor blue -AltColor yellow -Border -BorderFormat Mixed1 -BorderColor Blue

$File1 = "C:\Temp\MytabbedXML.xml"
$File2 = "C:\Temp\MyOriginalXML.xml"
$File3 = "C:\Temp\MyNormalized.xml"
$File4 = "C:\Temp\Modified.xml"

[XML] $XMLDoc1 = Get-Content $File1
[XML] $XMLDoc2 = Get-Content $File2
[XML] $XMLDoc3 = Get-Content $File3
[XML] $XMLDoc4 = Get-Content $File4

Write-Line "Hash of [$($File1)]: " -NoNewline
Get-XMLHash -XMLDoc $XMLDoc1 -UTF8

Write-Line "Hash of [$($File2)]: " -NoNewline
Get-XMLHash -XMLDoc $XMLDoc2 -UTF16

Write-Line "Hash of [$($File3)]: " -NoNewline
Get-XMLHash -XMLDoc $XMLDoc3

Write-Line "Hash of [$($File3)]: " -NoNewline
Get-XMLHash -XMLDoc $XMLDoc3 -UTF8

Write-Line "Hash of [$($File4)]: " -NoNewline 
Get-XMLHash -XMLDoc $XMLDoc4

Write-Line "Hash of [$($File4)]: " -NoNewline 
Get-XMLHash -XMLDoc $XMLDoc4 -UTF8

Write-Line "Hash of [$($File4)]: " -NoNewline 
Get-XMLHash -XMLDoc $XMLDoc4 -UTF16

##################################
# End of the tests show metrics #
##################################

Write-Host '------------------- Ending script -------------------' -ForegroundColor Yellow
$TimeSpentInDebugScript = New-TimeSpan -Start $DebugStart -Verbose:$False -ErrorAction SilentlyContinue
$TimeUnits = [ordered]@{TotalDays = "$($TimeSpentInDebugScript.TotalDays) D.";TotalHours = "$($TimeSpentInDebugScript.TotalHours) h.";TotalMinutes = "$($TimeSpentInDebugScript.TotalMinutes) min.";TotalSeconds = "$($TimeSpentInDebugScript.TotalSeconds) s.";TotalMilliseconds = "$($TimeSpentInDebugScript.TotalMilliseconds) ms."}
foreach ($Unit in $TimeUnits.GetEnumerator()) {if ($TimeSpentInDebugScript.$($Unit.Key) -gt 1) {$TimeSpentString = $Unit.Value;break}}
if (-not $TimeSpentString) {$TimeSpentString = "$($TimeSpentInDebugScript.Ticks) Ticks"}
Write-Host 'Ending : ' -ForegroundColor Yellow -NoNewLine
Write-Host $($MyInvocation.MyCommand) -ForegroundColor Magenta -NoNewLine
Write-Host ' - TimeSpent : ' -ForegroundColor Yellow -NoNewLine
Write-Host $TimeSpentString -ForegroundColor Magenta
