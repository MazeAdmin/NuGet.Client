$nupkgs = [IO.Path]::Combine( $PSScriptRoot, "nupkgs" );
$version = "5.0.1-rtm";

function New-NuGetPackage {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string]$Subfolder
    )
    If (-not $Subfolder) { $Subfolder = 'NuGet.Core' }

    "Creating package $Name"

    dotnet pack src/$Subfolder/$Name/$Name.csproj -o $nupkgs /p:PackageId=Maze.$Name /p:Version=$version -c Release --no-build

    "Patching $Name"

    $filename = (Get-ChildItem -Path $nupkgs -Filter "Maze.$Name.*.nupkg" | Select-Object -First 1).Name

    $zip =  [System.IO.Compression.ZipFile]::Open("$nupkgs/$filename", "Update")
    $configFile = $zip.GetEntry("Maze.$Name.nuspec");
    
    # Update the contents of the file
    
    $reader = [System.IO.StreamReader]($configFile).Open()
    $content = $reader.ReadToEnd()
    $reader.Dispose()
    
    $content = $content -replace 'dependency id="NuGet.', 'dependency id="Maze.NuGet.'
    
    $writer = [System.IO.StreamWriter]($configFile).Open()
    $writer.BaseStream.SetLength(0)
    
    $writer.Write($content)
    $writer.Dispose()
    
    $zip.Dispose()
    "Done"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

# New-NuGetPackage -Name 'NuGet.Commands'
# New-NuGetPackage -Name 'NuGet.Common'
# New-NuGetPackage -Name 'NuGet.Configuration'
# New-NuGetPackage -Name 'NuGet.Credentials'
# New-NuGetPackage -Name 'NuGet.DependencyResolver.Core'
# New-NuGetPackage -Name 'NuGet.Frameworks'
# New-NuGetPackage -Name 'NuGet.LibraryModel'
# New-NuGetPackage -Name 'NuGet.Packaging'
# New-NuGetPackage -Name 'NuGet.Packaging.Core'
# New-NuGetPackage -Name 'NuGet.ProjectModel'
New-NuGetPackage -Name 'NuGet.Protocol'
New-NuGetPackage -Name 'NuGet.Resolver'
New-NuGetPackage -Name 'NuGet.Versioning'