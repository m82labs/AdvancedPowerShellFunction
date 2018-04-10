function Get-SqlVersion {
    <#
        .SYNOPSIS
            Sample function showing off advanced function features in PowerShell.
            This function could be used in a pipeline to filter a list of SQL Server instances by version and OS.
    #>

    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='High')]
    param(
        [Parameter(Mandatory=$True,ValueFromPipelineByPropertyName)]
        [Alias('Instance')]
        [string]$SqlInstance,
        [Parameter(Mandatory=$True,ValueFromPipelineByPropertyName)]
        [ValidateSet(2012,2014,2016,2017,2018)] 
        [int]$CurrentMajorVersion
    )

    DynamicParam {
        if ($CurrentMajorVersion -ge 2017) {
            $ValSet = @('Windows','Linux')
        } else {
            $ValSet = @('Windows')
        }
         
        #Create a new ParameterAttribute Object
        $OSAttribute = New-Object System.Management.Automation.ParameterAttribute
        $OSAttribute.HelpMessage = "Please specify an OS to filter by:"
        
        # Create a validation set
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValSet)            

        # Create an attribute collection for our parameter
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $AttributeCollection.Add($OSAttribute)
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create the parameter
        $OSParam = New-Object System.Management.Automation.RuntimeDefinedParameter('OS', [string], $AttributeCollection)

        # Create and return the parameter dictionary
        $ParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $ParamDictionary.Add('OS', $OSParam)
        return $ParamDictionary
    }

    Begin {
        # bind the dynamic parameter
        $OS = $PsBoundParameters['OS']

        Write-Host "Getting SQL Server Version..."
        
        # Set the numeric version major
        if ( $CurrentMajorVersion ) {
            switch ( $CurrentMajorVersion) {
                2012 { $CurrentMajor = 11 }
                2014 { $CurrentMajor = 12 }
                2016 { $CurrentMajor = 13 }
                2017 { $CurrentMajor = 14 }
            }
        }

        # Set a query up
        [string]$VersionQuery = @"
        SELECT  @@SERVERNAME As ser,
                SERVERPROPERTY('productversion') AS ver,
                CASE WHEN @@VERSION LIKE '%Windows%' THEN 'Windows' ELSE 'Linux' END AS platform
        WHERE   CAST(SERVERPROPERTY('productmajorversion') AS VARCHAR(2)) LIKE '$($CurrentMajor)%'
                AND @@VERSION LIKE '%$($OS)%'
"@
        Write-Verbose "Query:`n$($VersionQuery)"
        Write-Debug -Message "Query:`n$($VersionQuery)"
    }

    Process {
        try {
            $Version = Invoke-SqlCmd -Query $VersionQuery -ServerInstance $SqlInstance -ErrorAction Stop

            if ( $Version ) {
                $Curr = New-Object -TypeName psobject
                $Curr | Add-Member -MemberType NoteProperty -Name 'Server' -Value $Version.ser
                $Curr | Add-Member -MemberType NoteProperty -Name 'Version' -Value $Version.ver
                $Curr | Add-Member -MemberType NoteProperty -Name 'Platform' -Value $Version.platform

                # Return objects as they are created
                Write-Output $Curr
            }
        }
        catch {
            Write-Host "$($SqlInstance): failed - $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    End {
    }
}