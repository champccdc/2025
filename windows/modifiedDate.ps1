param(
    [Parameter(Mandatory=$false)]
    [string]$Path,

    [Parameter(Mandatory=$false)][ValidateScript({ $_ -lt 0 })]
    [int]$TimeBack,

    [Parameter(Mandatory=$false)][ValidatePattern('^[dh]{1}$')]
    [char]$BackScale,

    [switch]$DirectoryOnly
)

#$parentDir = "C:\Users\liamg\OneDrive\Desktop\C++"
if (-Not ($PSBoundParameters.ContainsKey("TimeBack"))) { $TimeBack = -1 }
if (-Not ($PSBoundParameters.ContainsKey("BackScale"))) { $BackScale = 'd'}
if (-Not ($PSBoundParameters.ContainsKey("Path"))) { $Path = "C:\" }

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

function returnDirectoriesModified($table)
{
    $table = @()
    $numFilesChanged = 0

    if (Test-Path -Path $Path)#if $Path param is a directory
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

function returnFilesModified($table)
{
    $table = @()
    $fileAdded = 0
    if (Test-Path -Path $Path) #if $Path param is a directory
    {
        Get-ChildItem -LiteralPath $Path -Recurse | ForEach-Object {
            if((Test-Path -LiteralPath $_.FullName -PathType Leaf) -and ($_.LastWriteTime -gt (getTimeBack)))
            {
                $fileAdded++
                addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $table
            }
        }
    }
    else #if $Path param is a file
    {
        Get-Content $Path | ForEach-Object {
            Get-ChildItem -LiteralPath $_ -Recurse | ForEach-Object {
                if((Test-Path -LiteralPath $_.FullName -PathType Leaf) -and ($_.LastWriteTime -gt (getTimeBack)))
                {
                    $fileAdded++
                    addFileToObject $_.DirectoryName $_.Name $_.LastWriteTime.ToString("mm/dd HH:mm:ss") $table
                }
            }
        }
    }
    Write-Host $fileAdded

    $table
}

function addDirToObject($dir, $numFilesChanged, $lastModified, $changedTable)
{
    $changedTable += [pscustomobject]@{
        "Directory" = $dir
        "NumFilesChanged" = $numFilesChanged
        "Last Modified" = $lastModified
    }

    $changedTable
}

function addFileToObject($dir, $fileName, $lastModified, $changedTable)
{
    $changedTable += [pscustomobject]@{
        "Directory" = $dir
        "File Name" = $fileName
        "Last Modified" = $lastModified
    }

    $changedTable
}

if ($DirectoryOnly)
{
    $table = returnDirectoriesModified
}
else
{
    $table = returnFilesModified
}

$table | Format-Table | Out-String


