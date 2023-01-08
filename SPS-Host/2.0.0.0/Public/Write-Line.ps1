Write-Verbose "Processing : $($MyInvocation.MyCommand)"
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
            if ($Host.Name -eq 'ConsoleHost'){
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
    }
}
Export-ModuleMember -Function 'Write-Line'
