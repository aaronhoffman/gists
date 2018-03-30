param (
    [string]$path = "c:\dev\"
)

Write-Output "Recurse in $path for hidden .git folders..."

$gitdirs = Get-ChildItem -Recurse -Path $path -Force -Filter ".git"

Write-Output "Found: $($gitdirs.Length) repos"

$cwd = (Get-Item -Path ".\" -Verbose).FullName

foreach ($gitdir in $gitdirs)
{
    Write-Output "Fetch all for $($gitdir.Parent.FullName)"
    Set-Location $gitdir.Parent.FullName
    &git fetch --all
}

Set-Location $cwd