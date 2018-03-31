<#
CloudyWindows.io Escalation Toolkit: http://cloudywindows.io
#Run this directly from this location with: 
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1')

Grabs one or more sysinternals tools and places them in the target folder.

To use a different default tool list, call the code like this:

Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/DropSysinternalsTools.ps1') -ToolsToPull procexp.exe,procmon.exe

#>
#If you wish, set these variables in your shell before calling this script to override their defaults:
If (!$CloudyWindowsToolsRoot) { $CloudyWindowsToolsRoot = "$env:public\CloudyWindows.io_EscallationTools" }
If (!(Test-Path variable:CloudyWindowsToolCleanup)) {$CloudyWindowsToolCleanup = $True}

$Tool = @{
  Name = "FSCapture ScreenShot (Expiring Trial)"
  Description = "Free, Portable, has scrolling screenshots, captions, export combined to png or pdf"
  EXE = 'fscapture87\fscapture.exe' #include any zip subpath
  URL = 'http://www.faststonesoft.net/DN/FSCapture87.zip'
  SubFolder = 'fscapture'
  LastSegment = (("$($Tool.URL)") -split '/') | select -last 1
  CloudyWindowsToolFolder = "$CloudyWindowsToolsRoot\$($Tool.SubFolder)"
}

$ToolBanner = @"
*****************************************************
* CloudyWindows.io Escalation Toolkit:
*    $($Tool.Name) - $($Tool.Description)
"*****************************************************
"@
Write-Host $ToolBanner

If (!(Test-Path "$($Tool.CloudyWindowsToolFolder)")) { New-Item -ItemType Directory -Path "$($Tool.CloudyWindowsToolFolder)" -Force | Out-Null}
If (!(Test-Path "$($Tool.CloudyWindowsToolFolder)\$($Tool.EXE)"))
{
  Write-Host "Fetching $($Tool.Name)"
  Invoke-WebRequest -Uri "$($Tool.URL)" -outfile "$($Tool.CloudyWindowsToolFolder)\$($Tool.LastSegment)"

  If ($($Tool.LastSegment).endswith(".zip"))
  {
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory("$($Tool.CloudyWindowsToolFolder)\$($Tool.LastSegment)","$($Tool.CloudyWindowsToolFolder)")
  }
}

Write-Host "Waiting for $($Tool.CloudyWindowsToolFolder)\$($Tool.EXE) to exit"
$processhandle = start-process -FilePath "$($Tool.CloudyWindowsToolFolder)\$($Tool.EXE)" -wait -PassThru

If ($CloudyWindowsToolCleanup)
{
  While (!$processhandle.HasExited)
  {
    Write-host "Waiting for $($Tool.EXE) to exit"
  }
  Write-Host "Removing $($Tool.Name)"
  Remove-Item "$($Tool.CloudyWindowsToolFolder)" -Recurse -Force
}
