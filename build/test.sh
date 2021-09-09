echo "Conectar Oxiquim"
sfdx force:org:list

sfdx force:mdapi:convert -d deploy_prod -r manifiesto

#Para el paso a QA
#sfdx config:set defaultusername=administrador_nectia@nectia.com.qa
#sfdx force:mdapi:deploy -c -d manifiesto -u my-hub-orgQA -w 10 -l RunLocalTests -w 33

Para el paso a Preprod
sfdx config:set defaultusername=administrador_nectia@nectia.com.preprod
sfdx force:mdapi:deploy -c -d pruebaPackage -u my-hub-orgUAT2 -w 10 -l RunLocalTests -w 33

#Para el paso a producción
#sfdx config:set defaultusername=administrador_nectia@nectia.com
#sfdx force:mdapi:deploy -c -d pruebaPackage -u my-hub-Prod -w 10 -l RunLocalTests -w 33
sfdx force:mdapi:deploy:report
