Connect-SPOService -Url "https://YourTenantName-admin.sharepoint.com"
Connect-ExchangeOnline

$Result = @()
$AllSites = Get-SPOSite -IncludePersonalSite:$False -Limit All | Select Title, URL
$TotalSites = $AllSites.Count
$i = 1

ForEach ($Site in $AllSites) {
    Write-Progress -Activity "Processing $($Site.Title)" -Status "$i out of $TotalSites completed"
    $O365Group = $null
    $TeamEnabled = $false

    # Get the GroupId property for each site
    $GroupId = (Get-SPOSite $Site.URL -Detailed).GroupId.Guid

    if ($GroupId -ne $null) {
        $O365Group = (Get-UnifiedGroup -Identity $GroupId -ErrorAction SilentlyContinue)
        if ($O365Group -ne $null -and $O365Group.resourceProvisioningOptions -contains "Team") {
            $TeamEnabled = $true
        }
    }

    $Result += New-Object PSObject -property @{
        SiteName = $Site.Title
        SiteURL = $Site.URL
        GroupEnabled = if ($O365Group -ne $null) { $true } else { $false }
        GroupName = if ($O365Group -ne $null) { $O365Group.DisplayName } else { $null }
        GroupID = if ($O365Group -ne $null) { $GroupId } else { $null }
        GroupMail = if ($O365Group -ne $null) { $O365Group.PrimarySmtpAddress } else { $null }
        GroupOwner = if ($O365Group -ne $null) { $O365Group.ManagedBy -Join "," } else { $null }
        TeamEnabled = $TeamEnabled
    }
    $i++
}

$Result | Select SiteName, SiteURL, GroupEnabled, GroupName, GroupID, GroupMail, GroupOwner, TeamEnabled | Export-CSV "C:\TEMP\AllSPOSites.CSV" -NoTypeInformation -Encoding UTF8
