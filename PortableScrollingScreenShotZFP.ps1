<#
.SYNOPSIS
  Temporarily installs a screenshot tool capable of scrolling capture - automatic cleanup for zero footprint.
  Why and How Blog Post: https://cloudywindows.com/post/BLOG_URL_HERE
.DESCRIPTION
  CloudyWindows.io Escalation Toolkit: https://github.com/DarwinJS/CloudyWindows.ioEscalationToolkit

  Capturing evidence of breakage and evidence that fixes are effective is a fundamental part of ensuring escalations 

  iex (iwr 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1')
  iwr https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1' -outfile $env:public\PortableScrollingScreenShotZFP.ps1 ; & $env:public\PortableScrollingScreenShotZFP.ps1 -repeatintervalminutes 1
.COMPONENT
   CloudyWindows.io
.ROLE
  Escalation Toolkit (Zero Footprint)
#>

Param (
  [String]$CloudyWindowsToolsRoot = "$(If ("$env:CloudyWindowsToolsRoot") {"$env:CloudyWindowsToolsRoot"} else {"$env:public\CloudyWindows.io_EscalationTools"})",
  [String]$CloudyWindowsToolsSuppressCleanUp = "$(If ("$env:CloudyWindowsToolsSuppressCleanUp" -and "$env:CloudyWindowsToolsSuppressCleanUp" -ilike '*true*') {$True},
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

If ($CloudyWindowsToolSuppressCleanup)
{
  Write-Warning "Waiting for $CloudyWindowsToolFolder\$EXE to exit (Check for a tray item if exit did not occur when you expected"
}

$processhandle = start-process -FilePath "$CloudyWindowsToolFolder\$EXE" -wait -PassThru

If ($CloudyWindowsToolSuppressCleanup)
{
  While (!$processhandle.HasExited)
  {
    Write-host "Waiting for $EXE to exit"
  }
  Write-Host "Zero Footprint cleanup, use switch -CloudyWindowsToolsSuppressCleanUp or Environment Variable CloudyWindowsToolsSuppressCleanUp = True"
  Remove-Item "$CloudyWindowsToolFolder" -Recurse -Force
}
