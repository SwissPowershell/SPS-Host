Write-Verbose "Importing Module : $($MyInvocation.MyCommand)"
Function Write-Line {
<#
    .SYNOPSIS
        Writes customized colored output to a host
    .DESCRIPTION
        The function will give more option on write-host
        It will allow to create borders and colored text in a same line
    .EXAMPLE
        Write-Line -Message "My Text is [Beautiful] and I love this"
        Write to host "My Text is [Beautiful] and I love this" with 'Beautiful' in green
    .EXAMPLE
        Write-Line -Message "This is a title" -Border
        Write to host "This is a title" with a border
    .EXAMPLE
        Write-Line -Message "My flowers are`r`nbeautiful" -Border -BorderFormat Block -Align Right
        Write To host "My flowers are`r`nbeautiful" with border made of block and text aligned to right
    .PARAMETER Message
        Message to display
    .PARAMETER OpenChar
        That define where the colored part will begin (the char is not colored). Default '['
    .PARAMETER CloseChar
        That define where the colored part will end (the char is not colored). Default ']'
    .PARAMETER HideChar
        Will hide OpenChar and CloseChar when writing to host (but text remain colored)
    .PARAMETER Align
        Will align multiline text. Default 'Center'
            Authorized Values :
                Left
                Right
                Center
    .PARAMETER DefaultColor
        Specify default text color. Default 'Cyan'
    .PARAMETER AltColor
        Specify text between OpenChar and CloseChar color. Default 'Green'
    .PARAMETER BorderColor
        Specify Border color. Default Magenta
    .PARAMETER BorderFormat
        Specify the BorderFormat. Default 'Double'
            Autorized Values :
                Single
                SingleBold
                Double
                Mixed1
                Mixed2
                HalfBlock
                Block
                LightShade
                MediumShade
                DarkShade
    .PARAMETER BooleanFalseColor
        Specifies the color for colored string that is false
    .PARAMETER NoNewLine
        Specifies that the content displayed in the console does not end with a newline character.
    .INPUTS
        System.String
    .OUTPUTS
        None
        Write-Line sends the objects to the host. It does not return any objects. However, the host might display the objects that Write-Line sends to it.
    .LINK
        Online Version: http://go.microsoft.com/fwlink/p/?linkid=294029
        Write-Host
        Clear-Host 
        Out-Host 
        Write-Debug 
        Write-Error 
        Write-Output 
        Write-Progress 
        Write-Verbose 
        Write-Warning
    .NOTES
        Written by Yann Girardet
    .FUNCTIONALITY
        To give a sexier look to your host
    .FORWARDHELPTARGETNAME <Write-Host>
#>
    [CMDLetBinding()]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True
        )]
        [AllowEmptyString()]
        [String]
            ${Message},

        [Char]
            ${OpenChar}='[',
        
        [ValidateScript({if ($_ -ne $OpenChar){$True}Else{Throw "CloseChar '$_' can't be same as OpenChar '$OpenChar'"}})]
        [Char]
            ${CloseChar}=']',

        [Switch]
            ${HideChar},

        [ValidateSet('Left','Center','Right')]
        [String]
            ${Align} = 'Left',

        [ConsoleColor]
            ${DefaultColor}='Cyan',

        [ConsoleColor]
            ${AltColor}='Green',

        [ConsoleColor]
            ${BooleanFalseColor} = 'Red',

        [ConsoleColor]
            ${BorderColor} = 'Magenta',

        [Switch]
            ${Border},

        [ValidateSet('Single','SingleBold','Double','Mixed1','Mixed2','HalfBlock','Block','LightShade','MediumShade','DarkShade')]
        [String]
            ${BorderFormat} = 'Double',

        [Switch]
            ${NoNewLine}
        )
    BEGIN {
        #region Function initialisation DO NOT REMOVE
        [String] ${FunctionName} = $MyInvocation.MyCommand
        [DateTime] ${FunctionEnterTime} = [DateTime]::Now
        Write-Verbose "Entering : $($FunctionName)"
        #endregion Function initialisation DO NOT REMOVE
        Function Set-WLUiSize {
            Param(
                [ValidateScript({$_ -gt 0})]
                [Int32]
                    ${MaxLength}
                )
            if ($Host.Name -like '*Host'){
                #only change if in a console
                $PSHost = get-host
                $PSWindow = $PSHost.ui.rawui
                #Change BufferSize
                $Currentsize = $PSWindow.buffersize
                if ($CurrentSize.Width -le $MaxLength){
                    Write-Verbose 'Changing Host Buffer size'
                    $NewSize = $Currentsize 
                    $NewSize.width = $MaxLength
                    $PSWindow.buffersize = $NewSize
                }
                #Change WindowsSize
                $CurrentSize = $PSWindow.windowsize
                if ($CurrentSize.Width -le $MaxLength){
                    Write-Verbose 'Changing Host Windows size'
                    $NewSize = $Currentsize
                    $NewSize.width = $MaxLength
                    $PSWindow.windowsize = $NewSize
                }
            }
        }
        Function Get-WLBorder {
            Param(
                [ValidateSet('Single','SingleBold','Double','Mixed1','Mixed2','HalfBlock','Block','LightShade','MediumShade','DarkShade')]
                [String]
                    ${BorderFormat} = 'Double',
                [Int32]
                    ${Length},
                [Int32]
                    ${LeadingSpace} = 2
                )
            Switch ($BorderFormat){
                'Single' {
                    $TopLeft     = [char]0x250c
                    $HLineTop    = [char]0x2500
                    $TopRight    = [char]0x2510
                    $VLineLeft   = [char]0x2502
                    $VLineRight  = [char]0x2502
                    $BottomLeft  = [char]0x2514
                    $BottomRight = [char]0x2518
                    $HLineBottom = [char]0x2500
                }
                'SingleBold' {
                    $TopLeft     = [char]0x250f
                    $HLineTop    = [char]0x2501
                    $TopRight    = [char]0x2513
                    $VLineLeft   = [char]0x2503
                    $VLineRight  = [char]0x2503
                    $BottomLeft  = [char]0x2517
                    $BottomRight = [char]0x251b
                    $HLineBottom = [char]0x2501      
                }
                'Double' {
                    $TopLeft     = [char]0x2554
                    $HLineTop    = [char]0x2550
                    $TopRight    = [char]0x2557
                    $VLineLeft   = [char]0x2551
                    $VLineRight  = [char]0x2551
                    $BottomLeft  = [char]0x255a
                    $BottomRight = [char]0x255d
                    $HLineBottom = [char]0x2550          
                }
                'Mixed1' {
                    $TopLeft     = [char]0x2552
                    $HLineTop    = [char]0x2550
                    $TopRight    = [char]0x2555
                    $VLineLeft   = [char]0x2502
                    $VLineRight  = [char]0x2502
                    $BottomLeft  = [char]0x2558
                    $BottomRight = [char]0x255b            
                    $HLineBottom = [char]0x2550                
                }
                'Mixed2' {
                    $TopLeft     = [char]0x2553
                    $HLineTop    = [char]0x2500
                    $TopRight    = [char]0x2556
                    $VLineLeft   = [char]0x2551
                    $VLineRight  = [char]0x2551
                    $BottomLeft  = [char]0x2559
                    $BottomRight = [char]0x255c
                    $HLineBottom = [char]0x2500            
                }
                'HalfBlock' {
                    $TopLeft     = [char]0x258c
                    $HLineTop    = [char]0x2580
                    $TopRight    = [char]0x2590
                    $VLineLeft   = [char]0x258c
                    $VLineRight  = [char]0x2590
                    $BottomLeft  = [char]0x258c
                    $BottomRight = [char]0x2590
                    $HLineBottom = [char]0x2584            
                }
                'Block' {
                    $TopLeft     = [char]0x2588
                    $HLineTop    = [char]0x2588
                    $TopRight    = [char]0x2588
                    $VLineLeft   = [char]0x2588
                    $VLineRight  = [char]0x2588
                    $BottomLeft  = [char]0x2588
                    $BottomRight = [char]0x2588
                    $HLineBottom = [char]0x2588            
                }
                'LightShade' {
                    $TopLeft     = [char]0x2591
                    $HLineTop    = [char]0x2591
                    $TopRight    = [char]0x2591
                    $VLineLeft   = [char]0x2591
                    $VLineRight  = [char]0x2591
                    $BottomLeft  = [char]0x2591
                    $BottomRight = [char]0x2591
                    $HLineBottom = [char]0x2591            
                }
                'MediumShade' {
                    $TopLeft     = [char]0x2592
                    $HLineTop    = [char]0x2592
                    $TopRight    = [char]0x2592
                    $VLineLeft   = [char]0x2592
                    $VLineRight  = [char]0x2592
                    $BottomLeft  = [char]0x2592
                    $BottomRight = [char]0x2592
                    $HLineBottom = [char]0x2592            
                }
                'DarkShade' {
                    $TopLeft     = [char]0x2593
                    $HLineTop    = [char]0x2593
                    $TopRight    = [char]0x2593
                    $VLineLeft   = [char]0x2593
                    $VLineRight  = [char]0x2593
                    $BottomLeft  = [char]0x2593
                    $BottomRight = [char]0x2593
                    $HLineBottom = [char]0x2593            
                }
                Default {
                    $TopLeft     = [char]0x2554
                    $HLineTop    = [char]0x2550
                    $TopRight    = [char]0x2557
                    $VLineLeft   = [char]0x2551
                    $VLineRight  = [char]0x2551
                    $BottomLeft  = [char]0x255a
                    $BottomRight = [char]0x255d
                    $HLineBottom = [char]0x2550             
                }
            }
            $Borders = New-Object PSObject -Property @{
                TopLeft = $TopLeft
                HLineTop = $HLineTop
                TopRight = $TopRight
                VLineLeft = $VLineLeft
                VLineRight = $VLineRight
                BottomLeft = $BottomLeft
                BottomRight = $BottomRight
                HLineBottom = $HLineBottom
            }
            $Borders = New-Object PSObject -Property @{
                TopLine = "$($Borders.TopLeft)$(($Borders.HLineTop).ToString() * ($Length + $LeadingSpace))$($Borders.TopRight)"
                EmptyLine = "$($Borders.VLineLeft)$(' ' * ($Length + $LeadingSpace))$($Borders.VLineRight)"
                BottomLine = "$($Borders.BottomLeft)$($Borders.HLineBottom.ToString() * ($Length + $LeadingSpace))$($Borders.BottomRight)"
                VlineLeft = $Borders.VLineLeft
                VLineRight = $Borders.VLineRight
            }
            Write-Output $Borders
        }
        Function Get-MessageContent {
            Param(
                [String]
                    ${Message},
                [Char]
                    ${OpenChar},
                [Char]
                    ${CloseChar},
                [Boolean]
                    ${HideChar}
                )
            Function Get-OpenCloseList {
                Param(
                    [String]
                        ${Message},
                    [Char]
                        ${OpenChar},
                    [Char]
                        ${CloseChar}
                    )
                Function Get-AllChar {
                    Param([String] $Message, [Char] $Char)
                        $FindChar = Select-String -InputObject $Message -Pattern "\$($Char)" -AllMatches
                        if ($Null -ne $FindChar) {
                            Return $FindChar.Matches.Index
                        }Else{
                            Return $null
                        }
                }
                #Find all char
                $OpenList = @(Get-AllChar -Message $Message -Char $OpenChar)
                $CloseList = @(Get-AllChar -Message $Message -Char $CloseChar)
                #Filter Open Close
                $NewOpened,$NewClosed = [System.Collections.ArrayList]@(),[System.Collections.ArrayList]@()
                if (($OpenList.Count -gt 0) -and ($CloseList.count -gt 0)){
                    $OpenedCount,$ClosedCount,$TempClosedCount = 0,0,0
                    #Go trough all char until last close
                    for($i = 0;$i -le $CloseList[$CloseList.count - 1];$i ++){
                        if ($OpenList.Count -gt $Openedcount) {
                            if ($i -eq $OpenList[$OpenedCount]){
                                #$i is an open char 
                                $OpenedCount ++
                                if ($OpenedCount -eq ($ClosedCount + 1)){
                                    #this open is related to a close
                                    $NewOpened.add($i) | Out-Null
                                }
                            }
                        }
                        if ($i -eq $CloseList[$TempClosedCount]){
                            $TempClosedCount ++
                            if ($OpenedCount -gt $ClosedCount){
                                $ClosedCount ++
                                if ($ClosedCount -eq $OpenedCount){
                                    $NewClosed.add($i) | Out-Null
                                }
                            }
                        }
                    }
                    if ($NewOpened.Count -gt $NewClosed.Count){
                        #More open than close
                        $NewOpened = $NewOpened[0..$($NewOpened.Count - 2)]
                    }
                    if ($NewClosed.Count -gt $NewOpened.Count){
                        #More open than close
                        $NewClosed = $NewClosed[0..$($NewClosed.Count - 2)]
                    }
                    Write-Output $NewOpened,$NewClosed
                }
            }
            $LinesInfo= [System.Collections.ArrayList]@()
            $MaxLength = 0
            $Lines = $Message -split '\r\n'
            ForEach ($Line in $Lines) {
                #Getting Open and Close Position
                $OpenedList,$ClosedList = Get-OpenCloseList -Message $Line -OpenChar $OpenChar -CloseChar $CloseChar
                if ($HideChar -eq $True){
                    #Remove char from line length
                    $LineLength = $Line.Length - $OpenedList.Count - $ClosedList.Count 
                }Else{
                    $LineLength = $Line.Length
                } 
                $LineInfo = New-Object PSObject -Property @{
                    Line = $Line
                    OpenList = $OpenedList
                    CloseList = $ClosedList
                    LineLength = $LineLength
                }
                $LinesInfo.Add($LineInfo) | Out-Null
                if ($LineLength -gt $MaxLength) {
                    $MaxLength = $LineLength
                }
            }
            Write-Output $LinesInfo,$MaxLength
        }
        Function Write-MessageContent {
            Param(
                [PSObject]
                    ${Lines},
                [PSObject]
                    ${Borders},
                [ConsoleColor]
                    ${DefaultColor},
                [ConsoleColor]
                    ${AltColor},
                [ConsoleColor]
                    ${BorderColor},
                [Int32]
                    ${MaxLength},
                [Boolean]
                    ${HideChar},
                [Boolean]
                    ${NoNewLine}
                )
            Function Write-ColoredPart {
                Param(
                        ${Line},
                    [ConsoleColor]
                        ${DefaultColor},
                    [ConsoleColor]                    
                        ${AltColor},
                    [ValidateSet('Left','Center','Right')]
                    [String]
                        ${Align} = 'Center',
                    [Int32]
                        ${MaxLength},
                    [Boolean]
                        ${HideChar}
                )
                $Pos = 0
                $Index = 0
                [String]$MyString = $Line.Line
                if ($HideChar -eq $True){
                    $StringLen = $MyString.Length - $Line.OpenList.Count - $Line.CloseList.Count
                }Else{
                    $StringLen = $MyString.Length
                }
                $SpaceAfter = ''
                $SpaceBefore = ''
                Switch ($Align){
                        'Center'{
                                if ($StringLen -lt $MaxLength) {
                                    [Int32]$SpaceLenBefore = ($MaxLength - $StringLen) / 2
                                    [Int32]$SpaceLenAfter = ($MaxLength - $StringLen - $SpaceLenBefore)
                                    If ($SpaceLenBefore -gt 0){
                                        $SpaceBefore = ' ' * $SpaceLenBefore
                                    }Else{
                                        $SpaceBefore = ''
                                    }
                                    if ($SpaceLenAfter -gt 0){
                                        $SpaceAfter = ' ' * $SpaceLenAfter
                                    }Else{
                                        $SpaceAfter = ''
                                    }
                                }
                            }
                        'Right' {
                                if ($StringLen -lt $MaxLength) {
                                    [Int32]$SpaceLenBefore = ($MaxLength - $StringLen)
                                    $SpaceAfter = ""
                                    if ($SpaceLenBefore -gt 0){
                                        $SpaceBefore = ' ' * $SpaceLenBefore
                                    }Else{
                                        $SpaceBefore = ''
                                    }
                                }
                            }
                        'Left' {
                            if ($StringLen -lt $MaxLength) {
                                    [Int32]$SpaceLenAfter = ($MaxLength - $StringLen)
                                    $SpaceBefore = ''
                                    if ($SpaceLenAfter -gt 0){
                                        $SpaceAfter = ' ' * $SpaceLenAfter
                                    }Else{
                                        $SpaceAfter = ''
                                    }                        
                            }
                        }
                        default {
                            if ($StringLen -lt $MaxLength) {
                                [Int32]$SpaceLenAfter = ($MaxLength - $StringLen)
                                $SpaceBefore = ''
                                if ($SpaceLenAfter -gt 0){
                                    $SpaceAfter = ' ' * $SpaceLenAfter
                                }Else{
                                    $SpaceAfter = ''
                                }                        
                            }
                        }
                }
                Write-Host $SpaceBefore -NoNewline
                #the count should be equal
                if (($Line.OpenList.count -gt 0) -and ($line.CloseList.count -gt 0)) {
                    $ExitLoop = $false
                    Do {
                        if ($HideChar -eq $true){
                            $StartDefaultColor = $Pos
                            $DefaultColorLen = $Line.OpenList[$Index] - $Pos
                            $StartAltColor = $Line.OpenList[$Index] + 1
                            $AltColorLen = ($Line.CloseList[$Index] - $Line.OpenList[$Index]) - 1
                        }Else{
                            $StartDefaultColor = $Pos
                            $DefaultColorLen = ($Line.OpenList[$Index] - $Pos) + 1
    
                            $StartAltColor = $Line.OpenList[$Index] + 1
                            $AltColorLen = ($Line.CloseList[$Index] - $Line.OpenList[$Index]) - 1
                        }
                        if ($DefaultColorLen -gt 0){
                            $DefaultColorMessage = $MyString.Substring($StartDefaultColor,$DefaultColorLen)
                        }Else{
                            $DefaultColorMessage = ''
                        }
                        if ($AltColorLen -gt 0){
                            $AltColorMessage = $MyString.Substring($StartAltColor,$AltColorLen)
                        }Else{
                            $AltColorMessage = ''
                        }
                        
    
                        Write-Host $DefaultColorMessage -NoNewline -ForegroundColor $DefaultColor
                        if (($AltColorMessage -eq $False) -or ($AltColorMessage -eq '0')) {
                            Write-Host $AltColorMessage -NoNewline -ForegroundColor $BooleanFalseColor
                        }Else{
                            Write-Host $AltColorMessage -NoNewline -ForegroundColor $AltColor
                        }
                        if ($HideChar){
                            $Pos = $Line.CloseList[$Index] + 1
                        }Else{
                            $Pos = $Line.CloseList[$Index]
                        }
                        $Index = $Index + 1
                        if ($Index -ge $Line.OpenList.Count){
                            if ($HideChar){
                                $StartDefaultColor = $Line.CloseList[$Index - 1] + 1
                                $DefaultColorLen = $MyString.Length - ($Line.CloseList[$Index - 1] + 1)
                            }Else{
                                $StartDefaultColor = $Line.CloseList[$Index - 1]
                                $DefaultColorLen = $MyString.Length - $Line.CloseList[$Index - 1]
                            }
                            $DefaultColorMessage = $MyString.SubString($StartDefaultColor,$DefaultColorLen)
                            Write-Host $DefaultColorMessage -NoNewline -ForegroundColor $DefaultColor
                            $ExitLoop = $True
                        }
                    }
                    Until ($ExitLoop)
                }Else{
                    Write-Host $MyString -NoNewline -ForegroundColor $DefaultColor
                }
                Write-Host $SpaceAfter -NoNewline
            }
            if ($Borders-notlike $Null){
                Write-Host "$($Borders.TopLine)" -ForegroundColor $BorderColor
            }
            ForEach ($Line in $Lines){
                if ($Borders-notlike $Null) {
                    Write-Host "$($Borders.VLineLeft) " -ForegroundColor $BorderColor -NoNewline
                }
                Write-ColoredPart -Line $Line -DefaultColor $DefaultColor -AltColor $AltColor -Align $Align -MaxLength $MaxLength -HideChar $HideChar
                if ($Borders -notlike $Null) {
                    Write-Host " $($Borders.VLineRight)" -ForegroundColor $BorderColor -NoNewline
                }
                if (-Not $NoNewLine){
                    Write-Host $Null
                }
            }
            if ($Borders -notlike $Null){
                Write-Host "$($Borders.BottomLine)" -ForegroundColor $BorderColor
            }
    
        }
    }
    PROCESS {
        #region Function Processing DO NOT REMOVE
        Write-Verbose "Processing : $($FunctionName)"
        #region Function Processing DO NOT REMOVE
        $LinesInfo,$MaxLength = Get-MessageContent -Message $Message -OpenChar $OpenChar -CloseChar $CloseChar -HideChar $HideChar
        Set-WLUiSize -MaxLength $($MaxLength + 4)
        if ($Border){
            $Borders = Get-WLBorder -BorderFormat $BorderFormat -Length $MaxLength
        }Else{
            $Borders = $Null
        }
        Write-MessageContent -Lines $LinesInfo -Borders $Borders -DefaultColor $DefaultColor -AltColor $AltColor -BorderColor $BorderColor -Align $Align -MaxLength $MaxLength -HideChar $HideChar -NoNewLine $NoNewLine
    }
    END {
        #region Function closing  DO NOT REMOVE
        $TimeSpent = New-TimeSpan -Start $FunctionEnterTime -Verbose:$False -ErrorAction SilentlyContinue
        [String] ${TimeSpentString} = '';Switch ($TimeSpent) {{$_.TotalDays -gt 1} {$TimeSpentString = "$($_.TotalDays) D.";BREAK}{$_.TotalHours -gt 1} {$TimeSpentString = "$($_.TotalHours) h.";BREAK}{$_.TotalMinutes -gt 1}{$TimeSpentString = "$($_.TotalMinutes) min.";BREAK}{$_.TotalSeconds -gt 1}{$TimeSpentString = "$($_.TotalSeconds) s.";BREAK}{$_.TotalMilliseconds -gt 1}{$TimeSpentString = "$($_.TotalMilliseconds) ms.";BREAK}Default{$TimeSpentString = "$($_.Ticks) Ticks";BREAK}}
        Write-Verbose "Ending : $($FunctionName) - TimeSpent : $($TimeSpentString)"
        #endregion Function closing  DO NOT REMOVE
    }
}
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
            $DefaultColor='Cyan',
        [ConsoleColor]
            $AltColor='Green'
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
            Switch ($Answer.ToLower()){
                'yes' {$Ret_Val = $ValidChoice = $True}
                'y' {$Ret_Val = $ValidChoice = $True}
                'no' {$Ret_Val = $ValidChoice = $True}
                'n' {$Ret_Val = $ValidChoice = $True}
                'exit' {
                        $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                'e' {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                'quit' {
                    $Ret_Val = $null
                        if ($NoQuit){
                            Write-line "`t! Warning ! [$($Answer)] is not a valid choice..." -AltColor RED -DefaultColor Yellow
                            $ValidChoice = $False
                        }Else{
                            $ValidChoice = $True
                        }
                    }
                'q' {
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
        [String] ${TimeSpentString} = '';Switch ($TimeSpent) {{$_.TotalDays -gt 1} {$TimeSpentString = "$($_.TotalDays) D.";BREAK}{$_.TotalHours -gt 1} {$TimeSpentString = "$($_.TotalHours) h.";BREAK}{$_.TotalMinutes -gt 1}{$TimeSpentString = "$($_.TotalMinutes) min.";BREAK}{$_.TotalSeconds -gt 1}{$TimeSpentString = "$($_.TotalSeconds) s.";BREAK}{$_.TotalMilliseconds -gt 1}{$TimeSpentString = "$($_.TotalMilliseconds) ms.";BREAK}Default{$TimeSpentString = "$($_.Ticks) Ticks";BREAK}}
        Write-Verbose "Ending : $($FunctionName) - TimeSpent : $($TimeSpentString)"
        Write-Output $Ret_Val
    }
}
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
            $MenuColor = 'Cyan',
        [ConsoleColor]
            $MenuAltColor = 'Green',
        [ConsoleColor]
            $ChoiceColor = 'Yellow',
        [String]
            $Title,
        [ValidateSet('None','Single','SingleBold','Double','Mixed1','Mixed2','HalfBlock','Block','LightShade','MediumShade','DarkShade')]
        [String]
            $TitleBorderFormat = 'Double',
        [ConsoleColor]
            $TitleBorderColor = 'Magenta',
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
                    if ($TitleBorderStyle -eq 'None'){
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
                Write-Host ''
                Write-Line "Please make your choice [1-$($Menu.Count)] or [Enter] to Exit" -NoNewLine -DefaultColor $MenuColor -AltColor $MenuAltColor
                $UserChoice = Read-Host " "
                Try{
                    $UserChoice = [convert]::ToInt32($UserChoice)
                }
                Catch {}
                if ($UserChoice -eq '') {
                    $RetVal = $Null
                    $UserExited = $True
                }Elseif (($UserChoice -gt 0) -and ($UserChoice -le $($Menu.Count))){
                    $RetVal = $($Menu.Action[$UserChoice - 1])
                    $UserExited = $True
                }Else{
                    Write-Host ''
                    Write-Line "`t!! Error... [$($UserChoice)] is not a valid choice !!" -DefaultColor Yellow -AltColor RED
                    Write-Host ''
                }
            }Until($UserExited)
        }Else{
            Throw "'Menu' must contain at least 2 entry... First use Add-ChoiceItem to Create a Menu"
        }
    }
    END {
        #region Function closing  DO NOT REMOVE
        $TimeSpent = New-TimeSpan -Start $FunctionEnterTime -Verbose:$False -ErrorAction SilentlyContinue
        [String] ${TimeSpentString} = '';Switch ($TimeSpent) {{$_.TotalDays -gt 1} {$TimeSpentString = "$($_.TotalDays) D.";BREAK}{$_.TotalHours -gt 1} {$TimeSpentString = "$($_.TotalHours) h.";BREAK}{$_.TotalMinutes -gt 1}{$TimeSpentString = "$($_.TotalMinutes) min.";BREAK}{$_.TotalSeconds -gt 1}{$TimeSpentString = "$($_.TotalSeconds) s.";BREAK}{$_.TotalMilliseconds -gt 1}{$TimeSpentString = "$($_.TotalMilliseconds) ms.";BREAK}Default{$TimeSpentString = "$($_.Ticks) Ticks";BREAK}}
        Write-Verbose "Ending : $($FunctionName) - TimeSpent : $($TimeSpentString)"
        #endregion Function closing  DO NOT REMOVE
        Write-Output $RetVal
    }
}
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
            $MenuAction = $MenuItem
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
Function Format-XML {
    [CmdletBinding(DefaultParameterSetName='FromFile')]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True,
            ParameterSetName='FromFile'
        )]
        [String]
            ${XMLFile},
            [Parameter(
                Mandatory=$True,
                Position=1,
                ValueFromPipeline=$false,
                ParameterSetName='FromXMLDoc'
            )]
            [XML]
                ${XMLDoc},
            [Parameter(
                Position=2
            )]
            [Int32] 
                ${Indent} = 4,
            [Switch]
                ${AsString}
        )
    BEGIN {
        if ($PSCmdlet.ParameterSetName -eq 'FromFile') {
            try {
                [XML] $XMLDoc = Get-Content -Path $XMLFile -ErrorAction stop
            }
            Catch {
                Throw "Can't read the XML file $($XMLFile)"
            }
        }
    }
    PROCESS {
        $XmlWriterSettings = New-Object System.Xml.XmlWriterSettings
        $XmlWriterSettings.Indent = $true
        $XmlWriterSettings.IndentChars = (' ' * $Indent)
        Try {
            # Try to retrieve the XML document encoding 
            $Encoding = $XMLDoc.FirstChild.Encoding
            Switch ($Encoding) {
                'utf-16' {
                    $XmlWriterSettings.Encoding = [System.Text.Encoding]::Unicode
                }
                'Ainsi' {
                    $XmlWriterSettings.Encoding = [System.Text.Encoding]::Default
                }
                'utf-8' {
                    $XmlWriterSettings.Encoding = [System.Text.Encoding]::UTF8
                }
                Default {
                    Throw "Encoding [$($Encoding)] not supported"
                }
            }
        }Catch {
            # will use the default XMLWriterSettings encoding => UTF8
        }
        # Create a StringWriter to capture the output
        $StringWriter = New-Object System.IO.StringWriter
        # Create the XmlTextWriter object with our settings
        $XmlWriter = [System.Xml.XmlWriter]::Create($StringWriter, $XmlWriterSettings)
        # Write our XmlDocument to the XmlTextWriter
        $xmlDoc.WriteTo($XmlWriter)
        # Close the XmlTextWriter to ensure all data is written
        $XmlWriter.Close()
    }
    END {
        # Output the indented XML
        if ($AsString){
            $StringWriter.ToString()
        }else{
            [XML] $StringWriter
        }
    }
}
Function Get-XMLHash {
    [CmdletBinding(DefaultParameterSetName='FromFile')]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$True,
            ParameterSetName='FromFile'
        )]
        [String]
            ${XMLFile},
        [Parameter(
            Mandatory=$True,
            Position=1,
            ValueFromPipeline=$false,
            ParameterSetName='FromXMLDoc'
        )]
        [XML]
            ${XMLDoc},
        [Switch]
            ${UTF16},
        [Switch]
            ${UTF8}
        )
    BEGIN {
        if ($PSCmdlet.ParameterSetName -like 'FromFile') {
            try {
                [XML] $XMLDoc = Get-Content -Path $XMLFile -ErrorAction stop
            }
            Catch {
                Throw "Can't read the XML file $($XMLFile)"
            }
        }
        if ($UTF16 -or $UTF8) {
            $DetectEncoding = $false
        }else{
            $DetectEncoding = $true
        }
        if ($DetectEncoding) {
            Try {
                $Encoding = $XMLDoc.FirstChild.Encoding
                Switch ($Encoding) {
                    'utf-16' {
                        $UTF16 = $True
                    }
                    'utf-8' {
                        $UTF8 = $True
                    }
                    Default {
                        Throw "Encoding [$($Encoding)] not supported"
                    }
                }
            }Catch {
                Throw "Can't detect the XML's encoding... Please use -UTF16, -Ainsi or -UTF8 to specify the encoding"
            }
        }
    }
    PROCESS {
        [String] $NormalizedXML = Format-XML -XMLDoc $XMLDoc -Indent 4 -AsString
        $sha256 = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
        # Compute hash
        if ($UTF16){
            Write-Verbose "Getting hash as UTF16"
            $hash = $sha256.ComputeHash([Text.Encoding]::Unicode.GetBytes($NormalizedXML))
        }elseif ($UTF8){
            Write-Verbose "Getting hash as UTF8"
            $hash = $sha256.ComputeHash([Text.Encoding]::UTF8.GetBytes($NormalizedXML))
        }
        # Convert hash to hexadecimal string
        $hashString = [BitConverter]::ToString($hash) -replace '-', ''
    }
    END {
        # return the 64 char sha256 hash  
        return $hashString
    }
}
