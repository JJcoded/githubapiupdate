Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern int MessageBox(IntPtr hWnd, string text, string caption, uint type);
}
"@ -Language CSharp

# Function to display a fake error message box
function Show-Error {
    param (
        [string]$message,
        [string]$title
    )
    [WinAPI]::MessageBox([IntPtr]::Zero, $message, $title, 0x10)
}

# Make taskbar flicker (simulates unstable system)
function Taskbar-Flicker {
    Add-Type -Name WinAPI -Namespace System -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern int ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
"@
    $taskbar = [System.WinAPI]::FindWindow("Shell_TrayWnd", $null)
    for ($i=0; $i -lt 5; $i++) {
        [System.WinAPI]::ShowWindow($taskbar, 0)  # Hide taskbar
        Start-Sleep -Milliseconds 500
        [System.WinAPI]::ShowWindow($taskbar, 5)  # Show taskbar
        Start-Sleep -Milliseconds 500
    }
}

# Make the background appear like a BSOD (Fake BSOD)
function Fake-BSOD {
    Write-Host "Simulating Fake BSOD..." -ForegroundColor Red
    $bsod = New-Object -ComObject WScript.Shell
    $bsod.Popup("SYSTEM FAILURE: WATER DAMAGE DETECTED! CRITICAL MEMORY CORRUPTION!", 5, "Windows Fatal Error", 0x10)
    Start-Process "cmd.exe" -ArgumentList "/c color 1F && mode con cols=80 lines=25 && echo A critical system error has occurred... && timeout 10" -NoNewWindow -Wait
}

# Make the screen glitch (flashes inverted colors)
function Screen-Glitch {
    for ($i=0; $i -lt 3; $i++) {
        (Get-Process dwm).Kill() # Temporarily stop Windows Desktop Manager for flicker effect
        Start-Sleep -Milliseconds 300
        Start-Process "cmd.exe" -ArgumentList "/c color 4F && echo Memory integrity compromised! && timeout 3" -NoNewWindow -Wait
    }
}

# Main script execution
Show-Error "System Error: Motherboard Short Circuits Detected!" "Critical Hardware Failure"
Start-Sleep 1
Show-Error "Memory instability detected: Windows kernel corruption imminent!" "CRITICAL MEMORY FAULT"
Start-Sleep 1
Show-Error "Water detected on the motherboard. Components are shutting down!" "SYSTEM EMERGENCY!"
Start-Sleep 1

# Fake BSOD
Fake-BSOD

# Taskbar and screen glitches
Taskbar-Flicker
Screen-Glitch

# Fake shutdown sequence
Show-Error "System shutdown required to prevent damage! Immediate wipe recommended!" "FINAL WARNING"
Start-Sleep 3
Stop-Process -Name explorer -Force # Kills Windows Explorer (black screen effect)
Start-Sleep 5
Start-Process "shutdown.exe" -ArgumentList "/s /t 5 /c 'System instability detected! Shutdown required!'" -NoNewWindow -Wait
