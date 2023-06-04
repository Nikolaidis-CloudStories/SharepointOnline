Connect-SPOService -Url https://YouTenant-admin.sharepoint.com
$siteUrl = "https://YouTenant.sharepoint.com/sites/YourSite"
$users = Get-SPOUser -Site $siteUrl
$accessReport = @()

foreach ($user in $users) {
    $userObject = New-Object PSObject
    $userObject | Add-Member -MemberType NoteProperty -Name "LoginName" -Value $user.LoginName
    $userObject | Add-Member -MemberType NoteProperty -Name "IsSiteAdmin" -Value $user.IsSiteAdmin
    $userObject | Add-Member -MemberType NoteProperty -Name "Groups" -Value ($user.Groups | Out-String)
    $accessReport += $userObject
}

$accessReport | Export-Csv -Path "C:\Path\To\Export\File.csv" -NoTypeInformation


