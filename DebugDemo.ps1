function Test-Debug {
    [CmdletBinding()]
    param(
        [string]$Test
    )

    Write-Host "Parameter Value Supplied: $($Test)"
    Write-Debug "Explore the function variables. Type exit when done."

    if ( $Test -eq "blue" ) {
        Write-Error "No yellow!"
    }
}
