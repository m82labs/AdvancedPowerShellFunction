function Test-Debug {
    [CmdletBinding()]
    param(
        [string]$Test
    )

    # Set some variables to inspect
    [int]$RandomNumber1 = Get-Random -Minimum 0 -Maximum 999999
    [int]$NewNumber = $RandomNumber1 / 40

    Write-Host "Parameter Value Supplied: $($Test)"
    Write-Debug "Explore the function variables. Type exit when done."
}
