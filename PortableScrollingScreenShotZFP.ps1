<#
.SYNOPSIS
  Temporarily installs a screenshot tool capable of scrolling capture - automatic cleanup for zero footprint.
  Why and How Blog Post: https://cloudywindows.com/post/BLOG_URL_HERE
.DESCRIPTION
  CloudyWindows.io Escalation Toolkit: https://github.com/DarwinJS/CloudyWindows.ioEscalationToolkit

  Capturing evidence of breakage and evidence that fixes are effective is a fundamental part of ensuring escalations 

  iex (iwr 'https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1')
  iwr https://raw.githubusercontent.com/DarwinJS/WindowsEscalationToolkit/master/PortableScrollingScreenShotZFP.ps1' -outfile $env:public\PortableScrollingScreenShotZFP.ps1 ; & $env:public\PortableScrollingScreenShotZFP.ps1 -CloudyWindowsToolsSuppressCleanUp -CloudyWindowsToolsRoot "c:\users\public\test"
.COMPONENT
   CloudyWindows.io
.ROLE
  Escalation Toolkit (Zero Footprint)
#>

Param (
  [String]$CloudyWindowsToolsRoot = "$(If ("$env:CloudyWindowsToolsRoot") {"$env:CloudyWindowsToolsRoot"} else {"$env:public\CloudyWindows.io_EscalationTools"})",
  [String]$CloudyWindowsToolsSuppressCleanUp = $(If ("$env:CloudyWindowsToolsSuppressCleanUp" -and ("$env:CloudyWindowsToolsSuppressCleanUp" -ilike '*true*')) {"True"} else {"False"}),
  [String]$Name = "PicPick ScreenShot",
  [String]$Description = "Free, Portable, with screenshots of scrolling windows",
  [String]$EXE = 'picpick.exe',
  [String]$URL = 'http://ngwin.com/download/latest/picpick_portable.zip',
  [String]$SubFolder = 'picpick'
  )

$LastSegment = (("$URL") -split '/') | select -last 1
$CloudyWindowsToolFolder = "$CloudyWindowsToolsRoot\$SubFolder"
If ($CloudyWindowsToolsSuppressCleanUp -ilike '*true*') {[Bool]$BoolCloudyWindowsToolsSuppressCleanUp=$True} Else {[Bool]$BoolCloudyWindowsToolsSuppressCleanUp=$False}

If (@(Get-process $exe.replace('.exe','') -EA 0).count -gt 0) {Write-warning "`"$Name`" is already running, exiting..."; exit 0}

write-host "`$CloudyWindowsToolsSuppressCleanUp is $CloudyWindowsToolsSuppressCleanUp"

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

$WaitParam=$False
If (!$BoolCloudyWindowsToolsSuppressCleanUp)
{
  Write-Warning "Waiting for $CloudyWindowsToolFolder\$EXE to exit (Check for a tray item if programs does not appear to exit as expected)"
  $WaitParam = $True
}
else 
{
  Write-Warning "Please wait while $name is launched..."  
}

$processhandle = start-process -PassThru -FilePath "$CloudyWindowsToolFolder\$EXE" -wait:$WaitParam

If (!$BoolCloudyWindowsToolsSuppressCleanUp)
{
  While (!$processhandle.HasExited)
  {
    Write-host "Waiting for $EXE to exit"
  }
  Write-Host "Zero Footprint cleanup, use switch -CloudyWindowsToolsSuppressCleanUp or Environment Variable CloudyWindowsToolsSuppressCleanUp = True"
  Remove-Item "$CloudyWindowsToolFolder" -Recurse -Force
}
else 
{
  Write-Host "`"$Name`" is available for reuse in folder `"$CloudyWindowsToolFolder`""
}
