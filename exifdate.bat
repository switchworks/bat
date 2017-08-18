@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Add-Type -AssemblyName System.Drawing

$img = New-Object Drawing.Bitmap(".\test.jpg")
$item = $img.PropertyItems[0]
$item.Id = 36868
$item.Type = 2
# $item.Value = [System.BitConverter]::GetBytes("1981:12:24 00:11:22")
$item.Value = [System.Text.Encoding]::ASCII.GetBytes("1981:12:24 00:11:22")
$item.Len = $item.Value.Length
$img.SetPropertyItem($item)
$img.Save("./test2.jpg",[System.Drawing.Imaging.ImageFormat]::Jpeg)
$img.Dispose()
