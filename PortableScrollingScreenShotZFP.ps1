<#
.SYNOPSIS
  Temporarily installs a screenshot tool capable of scrolling capture - automatic cleanup for zero footprint.
  Why and How Blog Post: https://cloudywindows.com/post/BLOG_URL_HERE
.DESCRIPTION
  CloudyWindows.io Escalation Toolkit: https://github.com/DarwinJS/CloudyWindows.ioEscalationToolkit
  iex (iwr 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1')
  iwr https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1' -outfile $env:public\PortableScrollingScreenShotZFP.ps1 ; & $env:public\PortableScrollingScreenShotZFP.ps1 -repeatintervalminutes 1
.COMPONENT
   CloudyWindows.io
.ROLE
  Escalation Toolkit (Zero Footprint)
#>

Param (
  [String]$CloudyWindowsToolsRoot = "$(If ("$env:CloudyWindowsToolsRoot") {"$env:CloudyWindowsToolsRoot"} else {"$env:public\CloudyWindows.io_EscalationTools"})",
  [String]$CloudyWindowsToolsCleanUp = "$(If ("$env:CloudyWindowsToolsCleanUp") {"$env:CloudyWindowsToolsCleanUp"} else {"$true"})",
  [String]$Name = "PicPick ScreenShot",
  [String]$Description = "Free, Portable, has scrolling screenshots",
  [String]$EXE = 'picpick.exe',
  [String]$URL = 'http://ngwin.com/download/latest/picpick_portable.zip',
  [String]$SubFolder = 'picpick'
  )

  $LastSegment = (("$URL") -split '/') | select -last 1
  $CloudyWindowsToolFolder = "$CloudyWindowsToolsRoot\$SubFolder"

$ToolBanner = @"
*****************************************************
* CloudyWindows.io Escalation Toolkit:
*    $Name - $Description
"*****************************************************
"@
Write-Host $ToolBanner

If (!(Test-Path "$CloudyWindowsToolFolder")) { New-Item -ItemType Directory -Path "$CloudyWindowsToolFolder" -Force | Out-Null}
If (!(Test-Path "$CloudyWindowsToolFolder\$EXE"))
{
  Write-Host "Fetching `"$URL`" to `"$CloudyWindowsToolFolder\$LastSegment`""
  Invoke-WebRequest -Uri "$URL" -outfile "$CloudyWindowsToolFolder\$LastSegment"

  If ($LastSegment.endswith(".zip"))
  {
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory("$CloudyWindowsToolFolder\$LastSegment","$CloudyWindowsToolFolder")
  }
}

Write-Host "Waiting for $CloudyWindowsToolFolder\$EXE to exit"
Write-Warning "Even after exiting, you will also need to exit the tray icon before automatic cleanup will occur."
$processhandle = start-process -FilePath "$CloudyWindowsToolFolder\$EXE" -wait -PassThru

If ($CloudyWindowsToolCleanup)
{
  While (!$processhandle.HasExited)
  {
    Write-host "Waiting for $EXE to exit"
  }
  Write-Host "Removing Tool for zero foot print, use switch -CloudWindows"
  Remove-Item "$CloudyWindowsToolFolder" -Recurse -Force
}
