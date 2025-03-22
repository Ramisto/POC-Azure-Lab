# Create a resource group
# Author : Ramisto
# Date : 2019/11/05

# --- FILE IMPORT --- #
PARAM
( 
    [Parameter(Mandatory = $false)]
    [String]$inputGroup
);
########################################

# --- CONNECT TO AZURE ENVIRONMENT --- #
# Connexion mode
$login = $false

# Initialization of the variables
$subscriptionName = "[CHANGEME]"

# Connect to Azure
Import-Module -Name Az
Disable-AzDataCollection
if ($login)
{
    Connect-AzAccount
}

# List subscriptions
Get-AzSubscription

# Define the context of the subscription
Set-AzContext –SubscriptionName $subscriptionName
########################################

# --- VARIABLES --- #
$groups = Import-Csv -Path $inputGroup -Delimiter ";"
########################################

# --- CREATE A RESOURCE GROUP--- #
foreach ($group in $groups) 
{
    # If resource group does no exist
    if (!(Get-AzResourceGroup -Name $group.Name))
    {
        # Create a new resource group
        New-AzResourceGroup `
            -Name $group.Name `
            -Location $group.Location `
            -Tag @{Owner="[CHANGEME]"}

        Write-Host $group.Name "is created" -ForegroundColor Green
    }  
    else 
    {
        Write-Host $group.Name "already exist" -ForegroundColor Red
    }        
}
########################################