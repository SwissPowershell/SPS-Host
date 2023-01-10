Write-Verbose "Processing : $($MyInvocation.MyCommand)"
Function Read-Line {
<#
    .SYNOPSIS
        Display a question and wait user to answer using Read-Host
    .DESCRIPTION
        Display a question and wait user to type the authorized answer
    .EXAMPLE
        $ReturnValue = Read-Line -NoQuit
        Will display 'Continue [YES/NO] or [E] to Exit :'
    .EXAMPLE
        $ReturnValue = Read-Line -Message "Is it ok"
        Will display 'Is it ok, Continue [YES/NO] or [E] to Exit :'
    .PARAMETER Message
        Message displayed
    .PARAMETER NoQuit
        Default text will be '$Message Continue [YES/NO] :'
    .PARAMETER DefaultColor
        Specify default text color. Default 'Cyan'
    .PARAMETER AltColor
        Specify text between OpenChar and CloseChar color. Default 'Green'    
    .INPUTS
        System.Array
    .OUTPUTS
        System.Boolean
    .NOTES
        Written by Swiss Powershell
    .FUNCTIONALITY
        To display a question to host
    .FORWARDHELPTARGETNAME <read-Host>
#>
    [CMDLetBinding()]
    Param(
        [String]
            $Message,
        [Switch]
            $NoQuit,
        [ConsoleColor]
            $DefaultColor="Cyan",
        [ConsoleColor]
            $AltColor="Green"
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
        Do {
            if ($Message){$Line = "$($Message), "}
            if ($NoQuit){
                $Line = "$($Line)Continue [YES/NO]"
            }Else{
                $Line = "$($Line)Continue [YES/NO] or [E] to Exit"
            }
            Write-Line $Line -NoNewLine -DefaultColor $DefaultColor -AltColor $AltColor
            [String]$Answer = Read-Host " "
            Write-Verbose "Answer is : [$($Answer)]"
            $LAnswer = $Answer.ToLower()
            Switch ($LAnswer){
                "yes" {
                    $Ret_Val = $True
                    $ValidChoice = $True
                    }
                "y" {
                    $Ret_Val = $True
                    $ValidChoice = $True
                    }
                "no" {
                    $Ret_Val = $False
                    $ValidChoice = $True
                    }
                "n" {
                    $Ret_Val = $False
                    $ValidChoice = $True
                    }
                "exit" {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                "e" {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                "quit" {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                "q" {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                default {
                    Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                    $ValidChoice = $False
                }
            }
        }Until($ValidChoice)
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
        Write-Output $Ret_Val
    }
}
Export-ModuleMember -Function 'Read-Line'
