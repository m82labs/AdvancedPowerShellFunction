function Get-SqlVersion {
    param(
        $Instance
    )
    Write-Host "Getting SQL Server Version: " -NoNewLine
    try {
        $Version = Invoke-SqlCmd -Query "SELECT @@SERVERNAME AS Server, SERVERPROPERTY('productversion') AS Version" `
                                 -ServerInstance $Instance `
                                 -ErrorAction Stop `
                                 -Username sa `
                                 -Password myStrongPassword01
       Write-Host "done" -ForegroundColor Green

       $Version
    }
    catch {
        Write-Host "failed - $($_.Exception.Message)" -ForegroundColor Red
        return
    }
}