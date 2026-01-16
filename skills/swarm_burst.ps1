param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$JsonInput
)

$data = $JsonInput | ConvertFrom-Json
foreach ($file in $data.files) {
    $dir = Split-Path $file.path -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    Set-Content -Path $file.path -Value $file.content -Force
    Write-Host "🌊 Swarm-Burst: Written $($file.path)" -ForegroundColor Cyan
}
Write-Host "✅ Swarm-Burst: Completion of all 8 parallel targets." -ForegroundColor Green
