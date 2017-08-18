@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Get-ChildItem -Name | ForEach-Object -Process {
	$fn = $_
	if ($fn -match '^\d{8}'){
		switch -regex ($fn){
			'^\d{14}'{$date =  $fn -replace '^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2}).*','$1/$2/$3 $4:$5:$6'
				break}
			'^\d{8}'{$date =  $fn -replace '^(\d{4})(\d{2})(\d{2}).*','$1/$2/$3'}
		}
		Set-ItemProperty $fn -name CreationTime -value $date
		Set-ItemProperty $fn -name LastWriteTime -value $date
	}
}
