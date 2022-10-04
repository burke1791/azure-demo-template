# Azure ARM Template PoC

## Manual Actions After Initial Deployment

1. Connect synapse to a Github repository (import existing resources)
1. Allow your IP address access to the key vault
1. Grant yourself access to create secrets in the key vault
1. Add the postgres password to the key vault
1. Create managed private endpoints from synapse studio
  1. data lake (maybe)
  1. key vault
  1. postgres
1. After the private endpoints are provisioned, make sure to approve them from the target service side
1. Add linked services to synapse
  1. data lake through private endpoint (maybe)
  1. key vault
  1. postgres
    1. You will need to enable interactive authoring in the integration runtime in order to test the connection
    1. SSL is required


## Needs For Demo

1. Snowflake connection via private endpoint
  1. [Source](https://docs.snowflake.com/en/user-guide/privatelink-azure.html)