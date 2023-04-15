# README

## Deployment
#### 0 - Upload `vault-server.hcl` to File Share
```console
az storage file upload --account-name ${STORAGE_ACCOUNT_NAME} --share-name ${STORAGE_SHARE_NAME} --source vault-server.hcl
```

- example output:
```
Finished[#############################################################]  100.0000%
{
  "content_md5": "0x1c0x470xe20x630x890x500x2f0xc50xaa0x6c0x790xb20xc90x4a0x60x8c",
  "date": "2023-04-07T02:16:14+00:00",
  "etag": "\"0x8DB370E10807CFE\"",
  "file_last_write_time": "2023-04-07T02:16:14.8983038Z",
  "last_modified": "2023-04-07T02:16:14+00:00",
  "request_id": "4b000ac2-001a-005f-48f6-68dbf6000000",
  "request_server_encrypted": true,
  "version": "2021-06-08"
}
```

**NOTE:** we are passing the settings for auto-unseal via environment variables at ACA creation time (see below)


#### 1 - Build the Image
```console
az acr build --image vault:1.13.1 --registry ${ACR_NAME} --file Dockerfile . 
```

- example output:
```
Packing source code into tar to upload...
Uploading archived source code from '/var/folders/58/16lnyx815c183j6wzcbl_thc0000gn/T/build_archive_595e7ece88de48a1a65aad37162e897b.tar.gz'...
Sending context (3.021 KiB) to registry: vaultacr90580c8b...
Queued a build with ID: cx1
Waiting for an agent...
2023/04/05 02:26:05 Downloading source code...
2023/04/05 02:26:06 Finished downloading source code
2023/04/05 02:26:06 Using acb_vol_7c3198e0-daa0-4060-a341-63c53c09f930 as the home volume
2023/04/05 02:26:06 Setting up Docker configuration...
...
...
...
2023/04/05 02:26:40 Step ID: push marked as successful (elapsed time in seconds: 8.087897)
2023/04/05 02:26:40 The following dependencies were found:
2023/04/05 02:26:40
- image:
    registry: vaultacr90580c8b.azurecr.io
    repository: vault
    tag: 1.13.1
    digest: sha256:d5999d4c63b935be66809d8b134a7cb215f76bcf4c0f988e93c839d6a2ade45d
  runtime-dependency:
    registry: registry.hub.docker.com
    repository: library/scratch
    tag: latest
  buildtime-dependency:
  - registry: registry.hub.docker.com
    repository: library/debian
    tag: buster
    digest: sha256:235f2a778fbc0d668c66afa9fd5f1efabab94c1d6588779ea4e221e1496f89da
  - registry: registry.hub.docker.com
    repository: library/alpine
    tag: latest
    digest: sha256:124c7d2707904eea7431fffe91522a01e5a861a624ee31d03372cc1d138a3126
  git: {}

Run ID: cx1 was successful after 36s
```


#### 2 - Deploy Vault on ACA
- your ACA create command that's specific to you should be in the Terraform output
```console
az containerapp create --resource-group ${RG_NAME} \
  --name ${ACA_NAME} \
  --yaml app.yaml \
  --query properties.configuration.ingress.fqdn
```

**NOTE:** I am passing the app's config via a YAML file because I can't mount the Azure Storage File Share onto the container at runtime from just a CLI command alone.  Blame Microsoft.


#### 3 - Initialize Vault
```console
export VAULT_ADDR="https://[FQDN_OF_ACA_FROM_ABOVE_STEP]"
curl -s -X POST ${VAULT_ADDR}/v1/sys/init --data @init.json
```


## Clean up
#### 1 - Delete ACA
```console
az containerapp delete --resource-group ${RG_NAME} --name ${ACA_NAME}
```


#### 2 - Destroy Resources
```console
terraform destroy -auto-approve
```

**NOTE:** you may encounter an error with deleting the AKV key with Terraform because of [this issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/19307)
