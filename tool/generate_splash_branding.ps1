Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$logoPath = Join-Path $projectRoot "assets\images\route_logo.png"
$fontPath = Join-Path $projectRoot "assets\fonts\Inter-Variable.ttf"
$outputPath = Join-Path $projectRoot "assets\images\splash_branding.png"

$canvas = New-Object System.Drawing.Bitmap 500, 225, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$logo = [System.Drawing.Image]::FromFile($logoPath)
$fonts = New-Object System.Drawing.Text.PrivateFontCollection

try {
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $logoWidth = 320
    $logoHeight = [int][Math]::Round($logo.Height * ($logoWidth / $logo.Width))
    $logoX = [int](($canvas.Width - $logoWidth) / 2)
    $graphics.DrawImage($logo, $logoX, 0, $logoWidth, $logoHeight)

    $fonts.AddFontFile($fontPath)
    $font = New-Object System.Drawing.Font($fonts.Families[0], 19, ([System.Drawing.FontStyle]::Regular), ([System.Drawing.GraphicsUnit]::Pixel))
    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $textBounds = New-Object System.Drawing.RectangleF 0, 165, $canvas.Width, 45
    $graphics.DrawString("Supervised by Mohamed Nabil", $font, $brush, $textBounds, $format)

    $canvas.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
}
finally {
    if ($format) { $format.Dispose() }
    if ($brush) { $brush.Dispose() }
    if ($font) { $font.Dispose() }
    $fonts.Dispose()
    $logo.Dispose()
    $graphics.Dispose()
    $canvas.Dispose()
}
