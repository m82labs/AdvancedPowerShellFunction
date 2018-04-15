function Remove-AllProductionData {
    #[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='High')]
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        [string]$SQLInstance
    )

    if ($pscmdlet.ShouldProcess("ALL PRODUCTION DATA", "BLOWING AWAY")) {
        Write-Host "Deleting all the data..." -ForegroundColor Red
        Start-Sleep -Seconds $(Get-Random -Maximum 10 -Minimum 1)
        Write-Host "THE DEED IS DONE" -ForegroundColor Red
    }
}
