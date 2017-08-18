@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

$assemblies = (
 "System",
 "System.Runtime.InteropServices"
)

$src = @"

using System;
using System.Runtime.InteropServices;


public class glass{


[DllImport("user32.dll")]
internal static extern int SetWindowCompositionAttribute(IntPtr hwnd, ref WindowCompositionAttributeData data);

[StructLayout(LayoutKind.Sequential)]
internal struct WindowCompositionAttributeData
{
	public WindowCompositionAttribute Attribute;
	public IntPtr Data;
	public int SizeOfData;
}

internal enum WindowCompositionAttribute
{
	// ...
	WCA_ACCENT_POLICY = 19
	// ...
}

internal enum AccentState
{
	ACCENT_DISABLED = 0,
	ACCENT_ENABLE_GRADIENT = 1,
	ACCENT_ENABLE_TRANSPARENTGRADIENT = 2,
	ACCENT_ENABLE_BLURBEHIND = 3,
	ACCENT_INVALID_STATE = 4
}

[StructLayout(LayoutKind.Sequential)]
internal struct AccentPolicy
{
	public AccentState AccentState;
	public int AccentFlags;
	public int GradientColor;
	public int AnimationId;
}


private const int GW_HWNDNEXT = 2;
[DllImport("user32")]
private extern static int GetParent(int hwnd);
[DllImport("user32")]
private extern static int GetWindow(int hwnd, int wCmd);
[DllImport("user32")]
private extern static int FindWindow(
    String lpClassName, String lpWindowName);
[DllImport("user32")]
private extern static int GetWindowThreadProcessId(
    int hwnd, out int lpdwprocessid);
[DllImport("user32")]
private extern static int IsWindowVisible(int hwnd);

public static int GetHwndFromPid(int pid)
{
	int hwnd;
	hwnd = FindWindow(null, null);
	while (hwnd != 0)
	{
		if (GetParent(hwnd) == 0 && 
			IsWindowVisible(hwnd) != 0)
		{
			if (pid == GetPidFromHwnd(hwnd))
			{
				return hwnd;
			}
		}
		hwnd = GetWindow(hwnd, GW_HWNDNEXT);
	}
	return hwnd;
}
public static int GetPidFromHwnd(int hwnd)
{
    int pid;
    GetWindowThreadProcessId(hwnd, out pid);
    return pid;
}

	[STAThread]
	public static void Main(string[] args){

		if (args.Length!=0){
			AccentPolicy accentPolicy = new AccentPolicy();
			accentPolicy.AccentState = AccentState.ACCENT_ENABLE_BLURBEHIND;
			accentPolicy.AccentFlags = 0;
			accentPolicy.GradientColor = 0;
			accentPolicy.AnimationId = 0;
			IntPtr accentPtr = Marshal.AllocHGlobal(Marshal.SizeOf(accentPolicy));
			Marshal.StructureToPtr(accentPolicy, accentPtr, false);
			WindowCompositionAttributeData WCAD = new WindowCompositionAttributeData();
			WCAD.Attribute = WindowCompositionAttribute.WCA_ACCENT_POLICY;
			WCAD.SizeOfData = Marshal.SizeOf(accentPolicy);
			WCAD.Data = accentPtr;
			IntPtr hwnd = new IntPtr(GetHwndFromPid(int.Parse(args[0])));
			SetWindowCompositionAttribute(hwnd, ref WCAD);
		}

	}
}

"@

Add-Type -ReferencedAssemblies $assemblies -TypeDefinition $src -Language CSharp
[glass]::main($Args[0])