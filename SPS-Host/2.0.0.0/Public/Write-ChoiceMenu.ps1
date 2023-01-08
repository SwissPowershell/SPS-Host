Write-Verbose "Processing : $($MyInvocation.MyCommand)"
Function Write-ChoiceMenu {
<#
    .SYNOPSIS
        Display a Choice Menu
    .DESCRIPTION
        This function will display a Choice Menu
    .EXAMPLE
        $ReturnValue = Write-ChoiceMenu -Menu $ChoiceMenu -Title "My Menu"
        Will display a choice menu with "My Menu" as Title and $ChoiceMenu as content
    .PARAMETER Menu
        Content of the menu
    .PARAMETER Title
        Title of the choice list
    .INPUTS
        System.Array
    .OUTPUTS
        System.String
    .NOTES
        Written by Swiss Powershell
    .FUNCTIONALITY
        To display a Choice Menu
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    [CMDLetBinding()]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True
        )]
        [Array]
            $Menu,
        [ConsoleColor]
            $MenuColor = "Cyan",
        [ConsoleColor]
            $MenuAltColor = "Green",
        [ConsoleColor]
            $ChoiceColor = "Yellow",
        [String]
            $Title,
        [ValidateSet("None","Single","SingleBold","Double","Mixed1","Mixed2","HalfBlock","Block","LightShade","MediumShade","DarkShade")]
        [String]
            $TitleBorderFormat = "Double",
        [ConsoleColor]
            $TitleBorderColor = "Magenta",
        [ConsoleColor]
            $TitleColor = $MenuColor
        )
    BEGIN {
        #region Function initialisation DO NOT REMOVE
        [String] ${FunctionName} = $MyInvocation.MyCommand
        [DateTime] ${FunctionEnterTime} = [DateTime]::Now
        Write-Verbose "Entering : $($FunctionName)"
        #endregion Function initialisation DO NOT REMOVE
    }
    PROCESS {
        #region Function Processing DO NOT REMOVE
        Write-Verbose "Processing : $($FunctionName)"
        #region Function Processing DO NOT REMOVE
        if ($Menu -and $Menu.Count -gt 1){
            Do {
                if ($Title) {
                    if ($TitleBorderStyle -eq "None"){
                        Write-Line -Message $Title -DefaultColor $TitleColor
                    }Else{
                        Write-Line -Message $Title -Border -BorderFormat $TitleBorderFormat -BorderColor $TitleBorderColor -DefaultColor $TitleColor 
                    }
                }
                Write-Host ""
                $MenuCounter = 1
                ForEach ($Choice in $Menu){
                    Write-Line "`t$($MenuCounter))" -DefaultColor $ChoiceColor -NoNewLine
                    Write-Line "`t$($Choice.Item)" -DefaultColor $MenuColor -AltColor $MenuAltColor
                    $MenuCounter ++
                }
                Write-Host ""
                Write-Line "Please make your choice [1-$($Menu.Count)] or [Enter] to Exit" -NoNewLine -DefaultColor $MenuColor -AltColor $MenuAltColor
                $UserChoice = Read-Host " "
                Try{
                    $UserChoice = [convert]::ToInt32($UserChoice)
                }
                Catch {}
                if ($UserChoice -eq "") {
                    $RetVal = $Null
                    $UserExited = $True
                }Elseif (($UserChoice -gt 0) -and ($UserChoice -le $($Menu.Count))){
                    $RetVal = $($Menu.Action[$UserChoice - 1])
                    $UserExited = $True
                }Else{
                    Write-Host ""
                    Write-Line "`t!! Error... [$($UserChoice)] is not a valid choice !!" -DefaultColor Yellow -AltColor RED
                    Write-Host ""
                }
            }Until($UserExited)
        }Else{
            Throw "'Menu' must contain at least 2 entry... First use Add-ChoiceItem to Create a Menu"
        }
    }
    END {
        #region Function closing  DO NOT REMOVE
        $TimeSpent = New-TimeSpan -Start $FunctionEnterTime -Verbose:$False -ErrorAction SilentlyContinue
        [String] ${TimeSpentString} = ''
        Switch ($TimeSpent) {
            {$_.TotalDays -gt 1} {
                $TimeSpentString = "$($_.TotalDays) D."
                BREAK
            }
            {$_.TotalHours -gt 1} {
                $TimeSpentString = "$($_.TotalHours) h."
                BREAK
            }
            {$_.TotalMinutes -gt 1} {
                $TimeSpentString = "$($_.TotalMinutes) min."
                BREAK
            }
            {$_.TotalSeconds -gt 1} {
                $TimeSpentString = "$($_.TotalSeconds) s."
                BREAK
            }
            {$_.TotalMilliseconds -gt 1} {
                $TimeSpentString = "$($_.TotalMilliseconds) ms."
                BREAK
            }
            Default {
                $TimeSpentString = "$($_.Ticks) Ticks"
                BREAK
            }
        }
        Write-Verbose "Ending : $($FunctionName) - TimeSpent : $($TimeSpentString)"
        #endregion Function closing  DO NOT REMOVE
        Write-Output $RetVal
    }
}
Export-ModuleMember -Function 'Write-ChoiceMenu'
