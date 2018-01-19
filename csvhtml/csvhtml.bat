@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\" -Encoding UTF8|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

if ($Args[0] -ne $null){
	$html = gc 'temp.html'
	gc $Args[0] -Encoding UTF8 | ConvertFrom-CSV | %{
		$id = $_.id
		$value = $_.value
		$html = $html -replace "(id='$id'.*?>)",('$1'+"$value")
	}
	$html | Out-File -FilePath ((Get-Item $Args[0]).BaseName + ".html") -Encoding UTF8
}
