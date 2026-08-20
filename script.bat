@echo off
setlocal
title Microsoft Office Background Process Cleanup - Debug

set "LOG=%~dp0Office_Cleanup_Debug.log"


REM ============================================================
REM Initialize debug log
REM ============================================================

echo ============================================================ > "%LOG%"
echo Office Cleanup Debug >> "%LOG%"
echo Started: %date% %time% >> "%LOG%"
echo ============================================================ >> "%LOG%"
echo. >> "%LOG%"


REM ============================================================
REM Run Office cleanup
REM ============================================================

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Continue'; try { Write-Output ('User: ' + [Environment]::UserDomainName + '\' + [Environment]::UserName); $admin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator); Write-Output ('Running as administrator: ' + $admin); $apps=@('EXCEL','WINWORD','POWERPNT'); $targets=@(); foreach($app in $apps){ foreach($process in @(Get-Process -Name $app -ErrorAction SilentlyContinue)){ try { $process.Refresh(); if($process.MainWindowHandle -eq 0){ $targets += $process; Write-Output ('Found: ' + $process.ProcessName + ' PID=' + $process.Id) } } catch { Write-Output ('Detection error: ' + $_.Exception.Message) } } }; $found=$targets.Count; $closed=0; foreach($process in $targets){ try { Write-Output ('Terminating PID=' + $process.Id); $cim=Get-CimInstance Win32_Process -Filter ('ProcessId=' + $process.Id) -ErrorAction Stop; if($null -eq $cim){ Write-Output ('CIM process not found: PID=' + $process.Id) } else { $result=Invoke-CimMethod -InputObject $cim -MethodName Terminate -Arguments @{Reason=0} -ErrorAction Stop; Write-Output ('CIM return value: ' + $result.ReturnValue); Start-Sleep -Milliseconds 500; if(Get-Process -Id $process.Id -ErrorAction SilentlyContinue){ Write-Output ('FAILED: PID=' + $process.Id + ' is still running') } else { $closed++; Write-Output ('CLOSED: PID=' + $process.Id) } } } catch { Write-Output ('TERMINATION ERROR PID=' + $process.Id); Write-Output ('Message: ' + $_.Exception.Message); Write-Output ('Type: ' + $_.Exception.GetType().FullName); Write-Output ('Position: ' + $_.InvocationInfo.PositionMessage) } }; Write-Output ''; Write-Output ('Processes found : ' + $found); Write-Output ('Processes closed: ' + $closed) } catch { Write-Output ''; Write-Output 'FATAL ERROR'; Write-Output ('Message: ' + $_.Exception.Message); Write-Output ('Type: ' + $_.Exception.GetType().FullName); Write-Output ('Position: ' + $_.InvocationInfo.PositionMessage); exit 1 }" >> "%LOG%" 2>&1

set "PS_EXIT=%ERRORLEVEL%"


REM ============================================================
REM Save PowerShell exit code
REM ============================================================

echo. >> "%LOG%"
echo PowerShell exit code: %PS_EXIT% >> "%LOG%"
echo Finished: %date% %time% >> "%LOG%"


REM ============================================================
REM Display complete debug log
REM ============================================================

cls
type "%LOG%"

echo.
echo ============================================================
echo Debug log:
echo %LOG%
echo ============================================================
echo.
echo Press any key to close...
pause >nul

endlocal