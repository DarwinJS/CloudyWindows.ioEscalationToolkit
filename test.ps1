<#
CloudyWindows.io Escalation Toolkit: http://cloudywindows.io
#Run this directly from this location with: 
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1')

Grabs one or more sysinternals tools and places them in the target folder.

To use a different default tool list, call the code like this:

Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1') -ToolsToPull procexp.exe,procmon.exe

#>
Param (
  [String]$CloudyWindowsToolsRoot = "$(If ("$env:CloudyWindowsToolsRoot") {"$env:CloudyWindowsToolsRoot"} else {"$env:public\CloudyWindows.io_EscallationTools"})",
  [String]$CloudyWindowsToolsCleanUp = "$(If ("$env:CloudyWindowsToolsCleanUp") {"$env:CloudyWindowsToolsCleanUp"} else {"$true"})"  
)

write-host "CloudyWindowsToolsCleanUp: $CloudyWindowsToolsCleanUp"