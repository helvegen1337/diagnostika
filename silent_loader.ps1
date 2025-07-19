# Diagnostika v2.0 - Silent Loader
# Loads functions without any output

# Load the universal function silently
$UniversalPath = "$env:USERPROFILE\.diagnostika\powershell_universal.ps1"
if (Test-Path $UniversalPath) {
    # Load silently without any output
    . $UniversalPath | Out-Null
} else {
    # Only show error if file is missing
    Write-Host "Error: File powershell_universal.ps1 not found" -ForegroundColor Red
    Write-Host "Try reinstalling Diagnostika" -ForegroundColor Yellow
}

# Create aliases silently
Set-Alias -Name diag -Value Diagnostika -ErrorAction SilentlyContinue
Set-Alias -Name help -Value Diagnostika -ErrorAction SilentlyContinue
Set-Alias -Name menu -Value Diagnostika -ErrorAction SilentlyContinue 