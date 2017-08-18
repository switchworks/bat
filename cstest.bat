@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

$assemblies = (
 "System"
)

$src = @"

using System;
public static class cstest {
        public static void main(string[] args) {
            Console.WriteLine(args[0] + "!" + args[0] + "!" + args[0] + "!");
        }
    }

"@

Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $src -Language CSharp
[cstest]::main('hello!')
