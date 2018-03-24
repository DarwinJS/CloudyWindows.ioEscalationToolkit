<#
CloudyWindows.io Escalation Toolkit: http://cloudywindows.io
#Run this directly from this location with: 
Invoke-Expression (invoke-webrequest -uri 'https://raw.githubusercontent.com/DarwinJS/CloudyWindows.ioEscalationToolkit/master/PortableScrollingScreenShot.ps1')

#>
Param (
  [String]$CloudyWindowsToolsRoot = "$(If ("$env:CloudyWindowsToolsRoot") {"$env:CloudyWindowsToolsRoot"} else {"$env:public\CloudyWindows.io_EscallationTools"})",
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
$processhandle = start-process -FilePath "$CloudyWindowsToolFolder\$EXE" -wait -PassThru

If ($CloudyWindowsToolCleanup)
{
  While (!$processhandle.HasExited)
  {
    Write-host "Waiting for $EXE to exit"
  }
  Remove-Item "$CloudyWindowsToolFolder" -Recurse -Force
}
