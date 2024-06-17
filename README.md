# dspace

I have deployed one Windows VM and Storage Account
The code is pushed to github then from github to github action from githib actions to terraform cloud and from terraform cloud to Azure portal. 

Plan stage runs in plan branch if its successfull then we have to raise a pull request and merge it to main,
as the merge is done apply stage is trigger by github actions which then remains in terraform cloud to be approved as soon as we approve apply in terraform cloud then the infra is deployed. 


Also the VM takes credentials from Azure keyvault which is kept in another resource group so safety reasons so tha it can be common to other Vm in diffrent RG and also its not publicly accisible. 
