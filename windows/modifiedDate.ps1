param(
    [Parameter(Mandatory=$false)]
    [string]$Path, #put txt file to loop through directories listed in file or string of directory

    [Parameter(Mandatory=$false)][ValidateScript({ $_ -lt 0 })]
    [int]$TimeBack, #how far to go back

    [Parameter(Mandatory=$false)][ValidatePattern('^[dh]{1}$')]
    [char]$BackScale, #earliest date in hours or days

    [Parameter(Mandatory=$false)][ValidatePattern('^\.\w+')]
    [string[]]$ExcludeExtension, #exclude files with specified extensions

    [Parameter(Mandatory=$false)][ValidatePattern('^\.\w+')]
    [string[]]$IncludeExtension, #Only add files with specified extenstions

    [switch]$DirectoryOnly #cannot be used with -ExcludeExtension or -IncludeExtension
)

if ($DirectoryOnly -and ($PSBoundParameters.ContainsKey("ExcludeExtension") -or $PSBoundParameters.ContainsKey("IncludeExtension")))
{
    Write-Warning "Cannot use -DirectoryOnly with -IncludeExtension or -ExcludeExtension"
    exit 1
}
if (-Not ($PSBoundParameters.ContainsKey("TimeBack"))) { $TimeBack = -1 }
if (-Not ($PSBoundParameters.ContainsKey("BackScale"))) { $BackScale = 'd'}
if (-Not ($PSBoundParameters.ContainsKey("Path"))) { $Path = "C:\" }
if (-Not ((Test-Path -Path $Path) -or (Test-Path -Path $Path -PathType Leaf)))
{
    Write-Warning "Path specified does not lead to an existing directory or file"
    exit 1
}
if ($PSBoundParameters.ContainsKey("ExcludeExtension") -and $PSBoundParameters.ContainsKey("IncludeExtension"))
{
    Write-Warning "Cannot use both -ExcludeExtension and -IncludeExtension"
    exit 1
}
$extensionsIncluded = $false
if ($PSBoundParameters.ContainsKey(("IncludeExtension"))) { $extensionsIncluded = $true }

function getTimeBack()
{
    if ($BackScale -eq 'h')
    {
        return (Get-Date).AddHours($TimeBack)
    }
    else
    {
        return (Get-Date).AddDays($TimeBack)    
    }
}

function returnDirectoriesModified()
{
    $table = @()
    $numFilesChanged = 0

    if (Test-Path -Path $Path -PathType Container)#if $Path param is a directory
    {
        Get-ChildItem -LiteralPath $Path -Recurse -Directory | ForEach-Object {
            $numFilesChanged = (Get-ChildItem -LiteralPath $_.FullName | Where-Object { $_.LastWriteTime -gt (getTimeBack)}).Count
            if ($numFilesChanged -gt 0)
            {
                addDirToObject $_.FullName $numFilesChanged $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $table
            }   
        }
    }
    else #if $Path param is a file
    {
        Get-Content $Path | ForEach-Object {
            Get-ChildItem -LiteralPath $_ -Recurse -Directory | ForEach-Object {
                $numFilesChanged = (Get-ChildItem -LiteralPath $_.FullName | Where-Object { $_.LastWriteTime -gt (getTimeBack)}).Count
                if ($numFilesChanged -gt 0)
                {
                    addDirToObject $_.FullName $numFilesChanged $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $table
                }   
            }
        }
    }

    $table
}

function returnFilesModified()
{
    $table = @()
    if (Test-Path -Path $Path -PathType Container) #if $Path param is a directory
    {
        Get-ChildItem -LiteralPath $Path -Recurse | ForEach-Object {
            if((Test-Path -LiteralPath $_.FullName -PathType Leaf) -and ($_.LastWriteTime -gt (getTimeBack)) -and (-Not ($ExcludeExtension -contains $_.Extension)))
            {
                if ($extensionsIncluded)
                {
                    if ($IncludeExtension -contains $_.Extension)
                    {
                        addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $_.Extension $table
                    }
                }
                else
                {
                    addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $_.Extension $table
                }
            }
        }
    }
    else #if $Path param is a file
    {
        Get-Content $Path | ForEach-Object {
            Get-ChildItem -LiteralPath $_ -Recurse | ForEach-Object {
                if((Test-Path -LiteralPath $_.FullName -PathType Leaf) -and ($_.LastWriteTime -gt (getTimeBack)) -and (-Not ($ExcludeExtension -contains $_.Extension)))
                {
                    if ($extensionsIncluded)
                    {
                        if ($IncludeExtension -contains $_.Extension)
                        {
                            addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $_.Extension $table
                        }
                    }
                    else
                    {
                        addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $_.Extension $table
                    }
                }
            }
        }
    }
    $table
}

function addDirToObject($dir, $numFilesChanged, $lastModified, $changedTable)
{
    $changedTable += [pscustomobject]@{
        "Directory" = $dir
        "NumFilesChanged" = $numFilesChanged
        "LastModified" = $lastModified
    }

    $changedTable
}

function addFileToObject($dir, $fileName, $lastModified, $ext, $changedTable)
{
    $changedTable += [pscustomobject]@{
        "Directory" = $dir
        "FileName" = $fileName
        "LastModified" = $lastModified
        "Extension" = $ext
    }

    $changedTable
}

if ($DirectoryOnly)
{
    $table = returnDirectoriesModified
    $table
}
else
{
    $table = returnFilesModified
    $table | Sort-Object -Descending Extension | Select-Object Directory, FileName, LastModified
}
