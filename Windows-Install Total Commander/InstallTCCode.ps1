Function Get-RedirectedUrl
{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )
 
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

$url = 'http://totalcmd2.s3.amazonaws.com/tcmd852ax64.exe'
$codeSetupUrl = Get-RedirectedUrl -URL $url

$infPath = $PSScriptRoot + "\install.inf"
$tccodeSetup = "${env:Temp}\tcmd852ax64.exe"

try
{
    Invoke-WebRequest -Uri $codeSetupUrl -OutFile $tccodeSetup
}
catch
{
    Write-Error "Failed to download VSCode Setup"
}

try
{
    Start-Process -FilePath $tccodeSetup -ArgumentList "/VERYSILENT"
}
catch
{
    Write-Error 'Failed to install VSCode'
}