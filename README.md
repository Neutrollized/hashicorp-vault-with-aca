# Vault on Azure Container Apps

[Azure Container Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)

[Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

[Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)

[Azure Log Analytics Workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)

[Azure Container App Environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment)

In June 2021, I released [Free-tier Vault with Cloud Run](https://github.com/Neutrollized/hashicorp-vault-with-cloud-run), which allow you to deploy HashiCorp Vault on Google Cloud full managed serverless container platform, Cloud Run. GCP is my primary (and favorite) cloud provider, but I thought I'd try to make a similar deployment equivalent on Azure's [Container Instances](https://azure.microsoft.com/en-us/services/container-instances/) and AWS' [Fargate](https://aws.amazon.com/fargate/). I figured this would allow me to learn a bit more about Azure and AWS' offerings.

This is the latest addition to the family: [Azure Container Apps](https://azure.microsoft.com/en-us/products/container-apps)!

HashiCorp's products makes this possible by offering binaries for all sorts of architectures and operating systems, so whether you're on a Mac or Windows or Raspberry Pi, there's a binary for you!

**NOTE:** I am once again building my own Vault Docker image because I wanted to learn how the IAM piece works with Azure and also using their managed [Azure Container Registry](https://azure.microsoft.com/en-us/services/container-registry/).  You can just as easily use the HashiCorp provided Docker image when deploying your ACA.

This repo contains Terraform code that will deploy the required underlying infrastructure (Container Registry, Storage, Key Vault for auto-unseal), but the user will have to perform some tasks via the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli), `az`.  The details of those command can be found [here](./azure-container-instances/README.md)


## Pre-requisite: Service Principal to access Key Vault
You will need to create a Service Principal to access Key Vault:
```console
az ad sp create-for-rbac --name ACAVaultSP \
  --role "Key Vault Crypto User" \
  --scopes="[YOUR_SUBSCRIPTION_ID]"
```

Note down the `appId` and `password` in the output as these is your Client ID and Client Secret.

You then have to find out the SP's Object ID:
```console
az ad sp show --id [YOUR_APP_ID] --query 'id'
```

**NOTE:** you'll have to provide these values to the Terraform variables `autounseal_sp_client_id`, `autounseal_sp_client_secret`, and `autounseal_sp_object_id` respectively.


## How the Services are used
### Storage Account (Containers)
I'm referring to storage containers, which will serve as the [storage backend](https://www.vaultproject.io/docs/configuration/storage/azure) for the Vault data (the Google Cloud Storage or AWS S3 equivalent).

### Key Vault
Used for [auto-unseal](https://www.vaultproject.io/docs/concepts/seal#auto-unseal)

### Container Apps
Where the Vault binary will be run from.  

### Azure DevOps (optional, currently DISABLED)
You will have to [create an organization](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops) first and by default it woud be your username.  Azure is not my forte, but from what I learned playing around with [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/), you will need a file in your repo called `azure-pipelines.yaml`, except there's a lot of information that gets put in there that I wouldn't really be that comfortable putting in from an overall security point of view.  The recommended best practice here is to use [Service Connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml).  


So while I do have the a block of code here dedicated to setting up Azure DevOps for the building and deployment of the Vault ACI, I'm opting to leave it as DISABLED -- but for those of you have have more knowledge in the Azure DevOps domain, please feel free to make PR to educate me on how best to approach this.

#### Pre-requsite: Azure DevOps Parallelism Request 
I found this weird requirement to be so frustrating as it's not an automated process and takes ~2 days to get a response, but without fir getting this request approved, your ADO Pipeline won't run (and you'll instead get the error below) which is very frustrating.


```
Build
1 error(s), 0 warning(s)
	No hosted parallelism has been purchased or granted. To request a free parallelism grant, please fill out the following form https://aka.ms/azpipelines-parallelism-request
```

#### Restrictive Pipeline
The pipeline can only do a build!  If you want to deploy your built artifact, you need to define a [Release Pipeline](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/releases?view=azure-devops), which is an entirely separate thing. 
