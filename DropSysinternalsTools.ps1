<#
#Run this directly from this location with: 
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1')

Grabs one or more sysinternals tools and places them in the target folder.

To use a different default tool list, call the code like this:

Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1') -ToolsToPull procexp.exe,procmon.exe

#>

If (!$ToolsToPull)
{$ToolsToPull = ("procexp.exe;procmon.exe;autoruns.exe" -split ';')}
If (!$TargetFolder)
{$TargetFolder = "$env:public"}

ForEach ($Tool in $ToolsToPull)
{
    Invoke-WebRequest -Uri "http://live.sysinternals.com/$Tool" -outfile "$TargetFolder/$Tool"
}