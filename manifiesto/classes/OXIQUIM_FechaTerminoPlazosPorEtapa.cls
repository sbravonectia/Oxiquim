public class OXIQUIM_FechaTerminoPlazosPorEtapa {
	
    @InvocableMethod
    public static void establecerFechaTermino(List<Plazos_por_Etapa__c> plazosList) {
        List<Plazos_por_Etapa__c> updatePlazosList = new List<Plazos_por_Etapa__c>();
        System.debug('Caso__r.Id: '+plazosList[0].Caso__c);
        List<Plazos_por_Etapa__c> plazosCasosList = [select id,name,Fecha_de_Termino__c,Fecha_de_Inicio__c,Caso__c from Plazos_por_Etapa__c WHERE Caso__c =: plazosList[0].Caso__c ORDER BY CreatedDate ASC];	
        System.debug('plazosCasosList: '+plazosCasosList);
        Integer numeroDePlazos = plazosCasosList.size();

		  if(plazosCasosList.size()>1){			
				Plazos_por_Etapa__c pe = new Plazos_por_Etapa__c(Id=plazosCasosList[numeroDePlazos-2].Id,
				Fecha_de_Termino__c = plazosCasosList[numeroDePlazos-2].Fecha_de_Inicio__c);
				updatePlazosList.add(pe);
				if(plazosList[0].Name == 'Cerrado'){
					 pe = new Plazos_por_Etapa__c(Id=plazosList[0].Id,
					Fecha_de_Termino__c = plazosList[0].Fecha_de_Inicio__c);
					updatePlazosList.add(pe);
				}
			}
    	update updatePlazosList;
        System.debug('updatePlazosList: '+updatePlazosList);
    }
    
}