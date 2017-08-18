@powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Add-Type -AssemblyName PresentationFramework
$window = New-Object System.Windows.Window
$button = New-Object System.Windows.Controls.Button
$button.Content = 'Ç±ÇÒÇ…ÇøÇÕê¢äE'
$window.Content = $button
$window.ShowDialog()
