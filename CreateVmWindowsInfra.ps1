# Create a virtual network and a windows virtual machine in the resource group
# Author : Ramisto 
# Date : 2019/11/07

# --- FILE IMPORT --- #
PARAM
( 
    [Parameter(Mandatory = $false)]
    [String]$inputNetwork,
    [Parameter(Mandatory = $false)]
	[String]$inputVm
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
$vms = Import-Csv -Path $inputVm -Delimiter ";"
$networks = Import-Csv -Path $inputNetwork -Delimiter ";"
$getGroup = Get-AzResourceGroup -Name "[CHANGEME]"
$getVm = Get-AzVM -Name "[CHANGEME]"
$securePassword = ConvertTo-SecureString '[CHANGEME]' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($subscriptionName, $securePassword)
########################################

# --- CREATE A VIRTUAL MACHINE --- #
foreach ($network in $networks)
{
    foreach($vm in $vms)
    {    
    # If virtual machine does not exist
    if (!(Get-AzVM -Name $vm.VMName))
    {
        # Create a subnet configuration
        $subnetConfig = New-AzVirtualNetworkSubnetConfig `
            -Name $network.SubnetName `
            -AddressPrefix $network.SubnetAddressPrefix

        # Create a virtual network
        $vnetConfig = New-AzVirtualNetwork `
            -ResourceGroupName $getGroup.ResourceGroupName `
            -Location $getGroup.Location `
            -Name $network.NetworkName `
            -AddressPrefix $network.NetworkAddressPrefix `
            -Subnet $subnetConfig

        
        # Create a public IP address and specify a DNS name
        $pipConfig = New-AzPublicIpAddress `
            -ResourceGroupName $getGroup.ResourceGroupName `
            -Location $getGroup.Location `
            -AllocationMethod Static `
            -IdleTimeoutInMinutes 4 `
            -Name "PocPublicDns$(Get-Random)"
        
        # Create a virtual network card and associate with public IP address and NSG
        $nicConfig = New-AzNetworkInterface `
            -Name "PocNic" `
            -ResourceGroupName $getGroup.ResourceGroupName `
            -Location $getGroup.Location `
            -SubnetId $vnetConfig.Subnets[0].Id `
            -PublicIpAddressId $pipConfig.Id `

        # Create a virtual machine configuration
        $vmConfiguration = New-AzVMConfig `
            -VMName $vm.VMName `
            -VMSize $vm.VMSize | `
        Set-AzVMOperatingSystem `
            -Windows `
            -ComputerName $vm.VMName `
            -Credential $cred | `
        Set-AzVMSourceImage `
            -PublisherName $vm.PublisherName `
            -Offer $vm.Offer `
            -Skus $vm.Skus `
            -Version $vm.Version | `
        Add-AzVMNetworkInterface `
            -Id $nicConfig.Id

        # Create VM
        New-AzVM `
            -ResourceGroupName  $getGroup.ResourceGroupName `
            -Location $getGroup.Location `
            -VM $vmConfiguration
    }
    else 
    {
        Write-Host $getVm.Name "already exist" -ForegroundColor Red
    }
  }
}
########################################



