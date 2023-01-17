$directory = "C:\Users\blusc\AppData\Local\Temp\Windows-Tasks"
$regex = "^[\w.]+_[-\d]+\.xml$"
Write-Host """$($MyInvocation.MyCommand.Path)"" $args"

Get-ChildItem -Path $directory -Recurse -Filter "*.xml" | ForEach-Object {
    if ($_.Name -match $regex) {
        Write-Host $_.FullName
        $xml = [xml](Get-Content $_.FullName)
        $taskDescription = $xml.Task.RegistrationInfo.Description
        $newName = "{0} - {1}{2}" -f $_.BaseName, $taskDescription, $_.Extension
        Write-Host "$($_.Name) -> $newName"
        Rename-Item -Path $_.FullName -NewName $newName
    }
}
Function pause ($message) {
    if ($psISE) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    } else {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
# pause "Press any key to exit"