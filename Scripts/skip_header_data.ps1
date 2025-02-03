<#
    Simple ps script to remove header rows and save a copy of each csv file

    Used PS rather than Python or R just to experiment and learn it a bit 
#> 

#Input string Paths 
#Output new files to the same Paths with modified content (ignore header row)
function New-fileContent {
    param(
        [string[]]$Paths
    )
    ForEach($path in $Paths) {
        # Get content and skip the header row
        $content = Get-Content -Path $path | Select-Object -Skip 1
        # Create a new v2 file and save the content
        $parentPath = Split-Path -Path $path -Parent -Resolve
        $fileNameWithExt = Split-Path -Path $path -Leaf
        $fileNameWihoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileNameWithExt)
        $newFileName = "$($fileNameWihoutExt)_v2.csv"
        $newPath = Join-Path -Path $parentPath -ChildPath $newFileName
        Set-Content -Path $newPath -Value $content 
    }
}

$filePaths = @(
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\BegInv\BegInvFINAL12312016.csv",
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\EndInv\EndInvFINAL12312016.csv",
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\PurchasePrices\2017PurchasePricesDec.csv",
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Purchases\PurchasesFINAL12312016.csv",
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\Sales\SalesFINAL12312016.csv",
    "C:\Users\Customer\Documents\Certificates&Notes\Case_Study_2\VendorInvoices\InvoicePurchases12312016.csv"
)

New-fileContent -Paths $filePaths