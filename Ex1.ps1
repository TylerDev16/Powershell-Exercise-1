# Define the parent directory and subfolder names
$parentDir = "C:\TestingPurpose"
$subFolder1 = "SubFolder1"
$subFolder2 = "SubFolder2"

# Create the parent directory if it doesn't exist
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir | Out-Null
}

# Create the subfolders if they don't exist
$null = New-Item -ItemType Directory -Path "$parentDir\$subFolder1" -ErrorAction SilentlyContinue
$null = New-Item -ItemType Directory -Path "$parentDir\$subFolder2" -ErrorAction SilentlyContinue

# Create the test files
for ($i = 1; $i -le 50; $i++) {
    $fileName = "TypeATest$i.txt"
    $filePath = "$parentDir\$subFolder1\$fileName"
    New-Item -ItemType File -Path $filePath -Value "This is a test file $i"
}

for ($i = 51; $i -le 100; $i++) {
    $fileName = "TypeBTest$i.txt"
    $filePath = "$parentDir\$subFolder2\$fileName"
    New-Item -ItemType File -Path $filePath -Value "This is a test file $i"
}

# Move files with odd numbers to SubFolder2 and even numbers to SubFolder1
$files1 = Get-ChildItem -Path "$parentDir\$subFolder1" -File
foreach ($file in $files1) {
    $number = [int]($file.Name -replace "[^\d]")
    if ($number % 2 -eq 0) {
        $destination = "$parentDir\$subFolder1"
    }
    else {
        $destination = "$parentDir\$subFolder2"
    }
    Move-Item -Path $file.FullName -Destination $destination -Force
    Write-Host "Moved $($file.Name) to $destination"
}

$files2 = Get-ChildItem -Path "$parentDir\$subFolder2" -File
foreach ($file in $files2) {
    $number = [int]($file.Name -replace "[^\d]")
    if ($number % 2 -eq 0) {
        $destination = "$parentDir\$subFolder1"
    }
    else {
        $destination = "$parentDir\$subFolder2"
    }
    Move-Item -Path $file.FullName -Destination $destination -Force
    Write-Host "Moved $($file.Name) to $destination"
}

# Rename folder SubFolder1 to EvenFilesContainer and SubFolder2 to OddFilesContainer
$newSubFolder1Name = "EvenFilesContainer"
$newSubFolder2Name = "OddFilesContainer"
Rename-Item $parentDir\$subFolder1 $newSubFolder1Name
Write-Host "Renamed $subFolder1 to $newSubFolder1Name"
Rename-Item $parentDir\$subFolder2 $newSubFolder2Name
Write-Host "Renamed $subFolder2 to $newSubFolder2Name"


# Get the list of files in the subfolders
$subFolder1Files = Get-ChildItem -Path "$parentDir\$newSubFolder1Name" -File
$subFolder2Files = Get-ChildItem -Path "$parentDir\$newSubFolder2Name" -File

# Prepare the message for the output file
$dateString = Get-Date -Format "yyyyMMdd HH:mm"
$message = "As of $dateString files inside Testing Purpose are:`n`n"

# Append the header and the list of files from subfolder 1 to the message
$message += "Files in ${newSubFolder1Name}:`n"
foreach ($file in $subFolder1Files) {
    $message += "$($file.Name)`n"
}

# Append the header and the list of files from subfolder 2 to the message
$message += "`nFiles in ${newSubFolder2Name}:`n"
foreach ($file in $subFolder2Files) {
    $message += "$($file.Name)`n"
}

# Write the message to a file named MasterFile.txt
$masterFilePath = "$parentDir\MasterFile.txt"
Set-Content -Path $masterFilePath -Value $message

# Output the message to the console
Write-Output $message