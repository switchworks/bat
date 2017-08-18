# bat
bat(include PowerShell(include C#))

batでなんでもできそう

まほうのことば

@powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof
