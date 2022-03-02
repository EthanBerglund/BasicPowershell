# My first real Powershell program! 

# Takes parameters to decide where to create the backup file
Param(
    [string]$Path = './app',
    [string]$DestinationPath = './',
    [switch]$PathIsWebApp
)

# Checks that the backed up files are web apps
If ($PathIsWebApp -eq $True){
    Try{
        $ContainsApplicationFiles = "$((Get-ChildItem $Path).extension | Sort-Object -Unique)" -match '\.js|\.html|\.css'

        If ( -Not $ContainsApplicationFiles){
            Throw "Not a web app"
        } Else {
            Write-Host "Source files look good, continuing"
        }
    } Catch {
        Throw "No backup created due to $($_.Exception.Message)"
    }
}

# Checks that the Path variable is valid
If (-Not (Test-Path $Path)){
    Throw "The source directory $Path does not exist, please specify an existing directory"
}

#Creates the backup file name
$date = Get-Date -format "yyyy-MM-dd"
$DestinationFile = "$($DestinationPath + 'backup-' + $date + '.zip')"

#Creates the backup file (assuming it does not already exist) 
If (-Not (Test-Path $DestinationFile)){
    Compress-Archive -Path $Path -CompressionLevel 'Fastest' -DestinationPath "$($DestinationPath + 'backup-' + $date)"
    Write-Host "Created backup at $($DestinationPath + 'backup-' + $date + '.zip')"
} Else {
    Write-Error "Today's backup already exists"
}

