#!/bin/sh
#
# Usage: ./vhd-create-blob <resource_group> <location> <storage_account> <vhd_container_name>
#

if [ $# -ne 4 ]
then
  echo "Usage: $0 <resource_group> <location> <storage_account> <container_name>"
  exit 1
fi

KEYS_FILE="keys-$1-$3.txt"
SKU_TYPE="Premium_LRS"

echo "Creating resource group: $1"
az group create --name $1 --location $2

echo "Creating storage account: $3"
az storage account create --resource-group $1 --location $2 --name $3 --kind Storage --sku $SKU_TYPE

echo "Listing storage account keys"

SA_KEY=$(az storage account keys list --resource-group $1 --account-name $3 --query [0].value --output tsv)
echo "Make a note of your blob storage account key: $SA_KEY"

az storage account keys list --resource-group $1 --account-name $3 > $KEYS_FILE
cat $KEYS_FILE
echo "Keys are stored in $KEYS_FILE file. Keep it for further uploading a custom VHD image to '$4'"

echo "Creating storage container: $4"
az storage container create --account-name $3 --name $4

echo "Done"


