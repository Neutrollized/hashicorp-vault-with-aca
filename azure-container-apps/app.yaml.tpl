location: ${az_location}
name: ${vault_name}
resourceGroup: ${az_rg_name}
type: Microsoft.App/containerApps
identity:
  type: UserAssigned
  userAssignedIdentities:
   ? ${az_vault_user}
properties:
  environmentId: ${az_aca_env_id}
  managedEnvironmentId: ${az_aca_env_id}
  configuration:
    activeRevisionsMode: Single
    dapr: null
    ingress:
      allowInsecure: false
      clientCertificateMode: null
      corsPolicy: null
      customDomains: null
      exposedPort: 0
      external: true
      ipSecurityRestrictions: null
      stickySessions: null
      targetPort: 8200
      traffic:
        - latestRevision: true
          weight: 100
      transport: Auto
    maxInactiveRevisions: null
    registries:
    - identity: ${az_vault_user}
      passwordSecretRef: ''
      server: ${az_acr_name}.azurecr.io
      username: ''
    secrets: null
    service: null
  template:
    containers:
    - name: ${vault_name}
      image: vault:${vault_version}
      env:
      - name: AZURE_TENANT_ID
        value: ${az_tenant_id}
      - name: AZURE_CLIENT_ID
        value: ${vault_sp_client_id}
      - name: AZURE_CLIENT_SECRET
        value: ${vault_sp_client_secret}
      - name: VAULT_AZUREKEYVAULT_VAULT_NAME
        value: ${az_keyvault_name}
      - name: VAULT_AZUREKEYVAULT_KEY_NAME
        value: ${az_keyvault_key_name}
      command:
      - '/bin/vault'
      - 'server'
      - '-config'
      - '/etc/vault/vault-server.hcl'
      resources:
        cpu: 0.5
        ephemeralStorage: 2Gi
        memory: 1Gi
      volumeMounts:
      - mountPath: /etc/vault
        volumeName: azure-files-volume
    initContainers: null
    revisionSuffix: ''
    scale:
      minReplicas: 1
      maxReplicas: 1
    volumes:
      - name: azure-files-volume
        storageType: AzureFile
        storageName: ${az_aca_env_storage_name}
  workloadProfileName: null
