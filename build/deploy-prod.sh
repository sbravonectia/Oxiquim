#Convert to MDAPI format for deployment to prod
echo "##########Desplegando..."
sfdx force:org:list
sfdx force: mdapi:convert -d deploy_prod -r manifiesto
sfdx config:set defaultusername=administrador_nectia@nectia.com.qa
sfdx force:mdapi:deploy -d manifiesto -u my-hub-orgQA -w 10 
#-l RunLocalTests -w 33 --verbose --loglevel fatal.

#-l RunSpecifiedTests -r AMICAR_ChecklistGetJSONTest -w 33 --verbose --loglevel fatal
#-l RunLocalTests -d src -u my-hub-orgPruebasCI --verbose --loglevel fatal #Para todos por proyectos NO AMICAR!!!
#r: donde se guardara el archivo.
#-k listado de componentes
#-c Valida
#-f donde se encuentra el zip
#--loglevel variables que acompañan values are: trace, debug, info, warn, error, fatal
#-l = testlevel variables que lo acompañan 	RunLocalTests, RunAllTestsInOrg, RunSpecifiedTests
