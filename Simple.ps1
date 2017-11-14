function Get-SqlVersion {
    param(
        $Instance
    )
    Write-Host "Getting SQL Server Version: " -NoNewLine
    try {
        $Version = Invoke-SqlCmd -Query "SELECT @@SERVERNAME AS ser, SERVERPROPERTY('productversion') AS ver" `
                                 -ServerInstance $Instance `
                                 -ErrorAction Stop
       Write-Host "done" -ForegroundColor Green

       $Curr = New-Object -TypeName psobject
       $Curr | Add-Member -MemberType NoteProperty -Name 'Server' -Value $Version.ser
       $Curr | Add-Member -MemberType NoteProperty -Name 'Version' -Value $Version.ver
       
       Write-Output $Curr
    }
    catch {
        Write-Host "failed - $($_.Exception.Message)" -ForegroundColor Red
        return
    }
}