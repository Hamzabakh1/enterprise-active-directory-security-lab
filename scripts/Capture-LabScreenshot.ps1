# Captures the actual primary screen. Review screen contents and target before use.
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)][switch]$ApprovedCapture,
    [Parameter(Mandatory)][ValidatePattern('^.+\.png$')][string]$OutputPath,
    [Parameter(Mandatory)][string]$Step,
    [Parameter(Mandatory)][string]$SourceEnvironment
)
if (-not $ApprovedCapture) { throw 'Explicit -ApprovedCapture is required.' }
$fullPath = [IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $fullPath) { throw 'Refusing to overwrite an existing screenshot.' }
if (-not $PSCmdlet.ShouldProcess($fullPath, 'Capture primary screen and write provenance')) { return }
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$bounds = [Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object Drawing.Bitmap $bounds.Width,$bounds.Height
$graphics = [Drawing.Graphics]::FromImage($bitmap)
try {
    $graphics.CopyFromScreen($bounds.Location,[Drawing.Point]::Empty,$bounds.Size)
    $directory = [IO.Path]::GetDirectoryName($fullPath)
    [IO.Directory]::CreateDirectory($directory) | Out-Null
    $bitmap.Save($fullPath,[Drawing.Imaging.ImageFormat]::Png)
} finally {
    $graphics.Dispose()
    $bitmap.Dispose()
}
$hash = (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash
$metadata = [pscustomobject]@{
    Filename = [IO.Path]::GetFileName($fullPath)
    Step = $Step
    SourceEnvironment = $SourceEnvironment
    CapturedUtc = [DateTime]::UtcNow.ToString('o')
    SHA256 = $hash
    VerificationStatus = 'PENDING_REVIEW'
}
$metadata | ConvertTo-Json | Set-Content -LiteralPath ($fullPath + '.json') -Encoding UTF8
Write-Output $metadata
