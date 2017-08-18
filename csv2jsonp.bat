@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

if ($Args[0]){
	$csv = Get-Content mails.csv -Raw -Encoding UTF8
	$csv = $csv -replace '\n(?!")','\n'
	$csv = $csv | ConvertFrom-CSV | ConvertTo-Json
	$csv = "data=" + $csv
	Write-Output $csv | Set-Content -Encoding UTF8 ($Args[0] + '.json')
}
