Write-Verbose "Importing Module : $($MyInvocation.MyCommand)"

$FileToExclude = '_Example.ps1'
$PublicPS1 = Get-ChildItem -Path "$($PSScriptRoot)\Public\*.ps1" -ErrorAction SilentlyContinue -Exclude $FileToExclude
$PrivatePS1 = Get-ChildItem -Path "$($PSScriptRoot)\Private\*.ps1" -ErrorAction SilentlyContinue -Exclude $FileToExclude
$ClassPS1 = Get-ChildItem -Path "$($PSScriptRoot)\Class\*.ps1" -ErrorAction SilentlyContinue -Exclude $FileToExclude

ForEach ($PS1 in $PublicPS1) {
    Write-Verbose "Importing Public PS1 : $($PS1.BaseName)"
    . $PS1.Fullname
}

ForEach ($PS1 in $PrivatePS1) {
    Write-Verbose "Importing Private PS1 : $($PS1.BaseName)"
    . $PS1.Fullname
}

ForEach ($PS1 in $ClassPS1) {
    Write-Verbose "Importing Class PS1 : $($PS1.BaseName)"
    . $PS1.Fullname
}
