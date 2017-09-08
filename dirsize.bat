@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

if ($Args.Length -gt 0){
	if (Test-Path $Args[0] -PathType container){
		Get-ChildItem $Args[0] | ? { $_.PSIsContainer } | Select-Object Name,@{name="Size";expression={(Get-ChildItem $_.FullName -Recurse -Force | Measure-Object Length -Sum).Sum.ToString("#,#").PadLeft(15)}}
	}
}
