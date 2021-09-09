#Get the private key from the environment variable
echo "Logging into Salesforce Org"
echo "Authenticating org"

echo "Conectar OXIQUIM paso a QA"
sfdx alias:set my-hub-orgDESA=sbravo@nectia.com.sbx2021
sfdx auth:jwt:grant --clientid $SFDC_DESA_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_DESA_USER --instanceurl https://test.salesforce.com
sfdx alias:set my-hub-orgQA=administrador_nectia@nectia.com.qa
sfdx auth:jwt:grant --clientid $SFDC_QA_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_QA_USER --instanceurl https://test.salesforce.com

#echo "Conectar OXIQUIM paso a PREPROD"
#sfdx alias:set my-hub-orgQA=administrador_nectia@nectia.com.qa
#sfdx auth:jwt:grant --clientid $SFDC_QA_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_QA_USER --instanceurl https://test.salesforce.com
#sfdx alias:set my-hub-orgUAT2=administrador_nectia@nectia.com.preprod
#sfdx auth:jwt:grant --clientid $SFDC_UAT_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_UAT_USER --instanceurl https://test.salesforce.com

#echo "Conectar OXIQUIM paso a prod"
#sfdx alias:set my-hub-orgUAT2=administrador_nectia@nectia.com.preprod
#sfdx auth:jwt:grant --clientid $SFDC_UAT_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_UAT_USER --instanceurl https://test.salesforce.com
#sfdx alias:set my-hub-Prod=administrador_nectia@nectia.com
#sfdx auth:jwt:grant --clientid $SFDC_PROD_CLIENTID --jwtkeyfile JWT/server.key --username $SFDC_PROD_USER --instanceurl https://login.salesforce.com/
