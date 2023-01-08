Write-Verbose "Processing : $($MyInvocation.MyCommand)"
Function Add-ChoiceItem {
<#
    .SYNOPSIS
        Create / Update a choice Menu to be used with Write-ChoiceMenu
    .DESCRIPTION
        This function will create or update a choice menu that can be used with the Write-ChoiceMenu cmdlet
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -MenuItem "Get the process list" -MenuAction "Get-Process"
        Will Create a Menu then add a choice displayed as "Get the process list" and this choice will return "Get-Process"
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the time" -MenuAction "Get-Date -Format HH:mm:ss"
        Will add a choice to $ChoiceMenu displayed as "Get the time" and this choice will return "Get-Date -Format HH:mm:ss"
    .EXAMPLE
        $ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the date" -MenuAction "Get-Date -Format dd.MM.yyyy"
        Will add a choice to $ChoiceMenu displayed as "Get the date" and this choice will return "Get-Date -Format dd.MM.yyyy"
    .PARAMETER Menu
        Existing menu to update
    .PARAMETER MenuItem
        Item to display in the menu
    .PARAMETER MenuAction
        Item to return when MenuItem is chosen
    .INPUTS
        System.String
    .OUTPUTS
        System.String
    .NOTES
        Written by Swiss Powershell
    .FUNCTIONALITY
        To Make a Choice Menu
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    [CMDLetBinding()]
    Param(
        [Array]
            $Menu,
        [Parameter(
            Mandatory=$True
        )]
        [String]
            $MenuItem,
        [String]
            $MenuAction=$MenuItem
        )
    BEGIN {
        #region Function initialisation DO NOT REMOVE
        [String] ${FunctionName} = $MyInvocation.MyCommand
        [DateTime] ${FunctionEnterTime} = [DateTime]::Now
        Write-Verbose "Entering : $($FunctionName)"
        #endregion Function initialisation DO NOT REMOVE
        if (-not $Menu){$Menu = @()}
    
    }
    PROCESS {
        #region Function Processing DO NOT REMOVE
        Write-Verbose "Processing : $($FunctionName)"
        #region Function Processing DO NOT REMOVE
        $ChoiceItem = New-Object PSObject -Property @{
            Item = $MenuItem
            Action = $MenuAction
        }
        $Menu += $ChoiceItem
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
        Write-Output $Menu
    }
}
Export-ModuleMember -Function 'Add-ChoiceItem'
