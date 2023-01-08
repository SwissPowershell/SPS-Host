# SwissPowerShell Host Module
Powershell Module to enhance host display see [Help Page](https://swisspowershell.wordpress.com/revisited-host-module/)  
* Write-Line
* Write-ChoiceMenu
  * Add-ChoiceItem
* Read-Line

## Write-Line
  A colored and/or bordered write-host
  * Display text in the host with a colored zone
  * Display text in the host with colored border

### Examples
  * `Write-Line "The text between [Bracket] is [Colored]"`  
	![Write-Line Example 1](https://swisspowershell.files.wordpress.com/2015/12/write-line_example1.png)
  * `Write-Line "This text will be displayed with border" -Border`  
	![Write-Line Example 2](https://swisspowershell.files.wordpress.com/2015/12/write-line_example2.png)
  * `Write-Line "The text between [Bracket] is [Colored] but bracket are removed" -HideChar`  
	![Write-Line Example 3](https://swisspowershell.files.wordpress.com/2015/12/write-line_example3.png)
  * `Write-Line "The text between #sharp% and #percent% will be colored #sharp% and #percent% will not be displayed" -HideChar -OpenChar "#" -CloseChar "%"`  
	![Write-Line Example 4](https://swisspowershell.files.wordpress.com/2015/12/write-line_example4.png)

## Add-ChoiceItem
  Create a Choice Item to use with Write-ChoiceMenu
  * Create a Menu item that return a string

### Examples
  * `$ChoiceMenu = Add-ChoiceItem -MenuItem "Get the process list" -MenuAction "Get-Process"`
  * `$ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the time" -MenuAction "Get-Date -Format HH:mm:ss"`
  * `$ChoiceMenu = Add-ChoiceItem -Menu $ChoiceMenu -MenuItem "Get the date" -MenuAction "Get-Date -Format dd.MM.yyyy"`

## Write-ChoiceMenu
  A Choice Menu creator
  * Create a Menu into host where user have to select between different choice defined by Add-ChoiceItem
    * Return `$null` if user choose to exit

### Example
  * `$ReturnValue = Write-ChoiceMenu -Menu $ChoiceMenu -Title "My Menu"`  
	![Write-ChoiceMenu and Add-ChoiceItem](https://swisspowershell.files.wordpress.com/2015/12/write-choicemenu_example1.png)

## Read-Line
  A predefined read-host
  * Return `$Null` if Quit (except if noquit) (not case sensitive and also accept Q and E or Exit)
  * Return `$True` if Yes (not case sensitive and also accept Y)
  * Return `$False` if No (not case sensitive and also accept N)

### Examples
  * `$ReturnValue = Read-Line -Message "Is it Ok"`  
	![Read-Line Example 1](https://swisspowershell.files.wordpress.com/2015/12/read-line_example1.png)
  * `$ReturnValue = Read-Line -Message "Is it Ok" -noquit`  
	![Read-Line Example 2](https://swisspowershell.files.wordpress.com/2015/12/read-line_example2.png)
