# Create Azure VM's

## List available VM's

```
az vm image list --output table
```

## Create a new VM instance

Create a resource group:

```
az group create --name <myResourceGroupVM> --location eastus
```

Create the VM:

```
az vm create --resource-group <myResourceGroupVM> --name <myVM> --image UbuntuLTS --ssh-key-value ~/.ssh/id_rsa.pub --admin-username ubuntu
```
