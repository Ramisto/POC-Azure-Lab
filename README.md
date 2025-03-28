# POC Azure Lab

## Description

Several powershell scripts for testing Microsoft Azure functionalities.

| Script | Description |
|---|---|
| [CreateVmWindowsInfra.ps1](./CreateVmWindowsInfra.ps1) | Create a virtual network and a windows virtual machine in the resource group |
| [CreateNewResourceGroup.ps1](./CreateNewResourceGroup.ps1) | Create a new resource group |
 
## Getting Started

### Pre-requisites

* Install [azure powershell module](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-13.3.0)
* An azure account with appropriate privileges to deploy resources

### Installing

`git clone https://github.com/Ramisto/POC-Azure-Lab.git`

### Variables to be modified

- **CreateVmWindowsInfra.ps1** :
  - CSV files 
  - [line 20] $subscriptionName = Enter your Azure subscription name
  - [line 40] $getGroup = Define your Azure resource group name
  - [Line 41] $getVm = Define your Azure VM name
  - [Line 42] $securePassword = Enter your password

- **CreateNewResourceGroup.ps1** :
  - CSV files
  - [line 18] $subscriptionName = Enter your Azure subscription name
  - [line 49] -Tag @{Owner="[CHANGEME]"} = Enter your owner tag

## Usage

Open the powershell script with the "Windows Powershell ISE" console.

## Help

Create an [issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue) to get help.

## Contributor

If you want to contribute, read the [CONTRIBUTING](/CONTRIBUTING.md) file to learn how to do so.

## Code of conduct

Here is our [CODE_OF_CONDUCT](/CODE_OF_CONDUCT.md) for all contributors.
