#!/bin/sh
# Prepare Azure infrastructure for CloudForms appliance deployment
#
# Usage: azure-cf-infra.sh <resource_group> <location> [<storage_account> [<storage_container> [<vnet> [<subnet>]]]]
#

LOCATION="westeurope"
STORAGE_ACCOUNT="cfstorage"
STORAGE_CONTAINER="cfcontainer"
VNET="cfvnet"
SUBNET="cfsubnet"
SKU_TYPE="Premium_LRS"
CF_ADMIN_USERNAME="cfadmin"

if [ $# -eq 0 ] || [ $# -gt 6 ]
then
   echo "Usage: $0 <resource_group> [<location> [<storage_account> [<storage_container> [<vnet> [<subnet>]]]]]"
   echo ""
   echo "Defaults:"
   echo "    <location> ${LOCATION}"
   echo "    <storage_account> ${STORAGE_ACCOUNT}"
   echo "    <storage_container> ${STORAGE_CONTAINER}"
   echo "    <vnet> ${VNET}"
   echo "    <subnet> ${SUBNET}"
   echo ""
   exit 1
fi

resource_group="$1"

if [ -z "$2" ]
then
   location=${LOCATION}
else
   location="$2"
fi

if [ -z "$3" ]
then
   storage_account=${STORAGE_ACCOUNT}
else
   storage_account="$3"
fi

if [ -z "$4" ]
then
   storage_container=${STORAGE_CONTAINER}
else
   storage_container="$4"
fi

if [ -z "$5" ]
then
   vnet=${VNET}
else
   vnet="$5"
fi

if [ -z "$6" ]
then
   subnet=${SUBNET}
else
   subnet="$6"
fi

echo "Parameters: ${resource_group} ${location} ${storage_account} ${storage_container} ${vnet} ${subnet}"

echo "Creating resource group"
az group create --name ${resource_group} --location ${location}

echo "Creating storage account: ${storage_account}"
az storage account create -l ${location} -n ${storage_account} -g ${resource_group} --sku ${SKU_TYPE}

echo "Getting storage account connection string"
conn_string_file="${storage_account}-${resource_group}-connection"
az storage account show-connection-string -n ${storage_account} -g {resource_group} > ${conn_string_file}
echo "Connection string is stored in the file '${conn_string_file}'"
cat ${conn_string_file}

# TODO: automatically parse the connecting string and store it in 'storage_conn_string' variable

echo "Creating storage container: ${storage_container}"
az storage container create -n ${storage_container}

echo "Creating virtual network: ${vnet} ${subnet}"
az network vnet create -g ${resource_group} --name ${vnet} --subnet-name ${subnet}

echo "Done"
exit 0

