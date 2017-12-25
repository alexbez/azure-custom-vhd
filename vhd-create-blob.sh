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

echo "Creating resource group: $1"
az group create --name $1 --location $2

echo "Creating storage account: $3"
az storage account create --resource-group $1 --location $2 --name $3 --kind Storage --sku Premium_LRS

echo "Listing storage account keys"
az storage account keys list --resource-group $1 --account-name $3 > storage-account-keys.txt
cat storage-account-keys.txt
echo "Keys are stored in $KEYS_FILE file. Keep it for further uploading a custom VHD image to '$4'"

echo "Creating storage container: $4"
az storage container create --account-name $3 --name $4

echo "Done"


