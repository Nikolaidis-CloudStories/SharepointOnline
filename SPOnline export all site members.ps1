# Connect to SharePoint Online
Connect-SPOService -Url https://YourTenant-admin.sharepoint.com

# Get all sites in SharePoint
$sites = Get-SPOSite -Limit All

# Initialize an array to store the access report
$accessReport = @()

# Iterate through each site
foreach ($site in $sites) {
    $siteUrl = $site.Url
    $users = Get-SPOUser -Limit ALL -Site $siteUrl

    # Iterate through each user in the site
    foreach ($user in $users) {
        $userObject = New-Object PSObject
        $userObject | Add-Member -MemberType NoteProperty -Name "SiteUrl" -Value $siteUrl
        $userObject | Add-Member -MemberType NoteProperty -Name "LoginName" -Value $user.LoginName
        $userObject | Add-Member -MemberType NoteProperty -Name "IsSiteAdmin" -Value $user.IsSiteAdmin 
        $userObject | Add-Member -MemberType NoteProperty -Name "Groups" -Value ($user.Groups | Out-String)
        $accessReport += $userObject
    }
}

 # Export the access report to a CSV file
$accessReport | Export-Csv -Path "C:\Export\File.csv" -NoTypeInformation