@isTest
private class OXIQUIM_FechaTerminoPlazosPorEtapa_Test {
	@isTest static void test() {
        OXIQUIM_fechaTerminoPlazosPorEtapa.establecerFechaTermino(crearPlazoPorEtapa(crearCaso()));
    }  
    
    private static Case crearCaso(){
         Case sobj = new Case(
          AccountId = null,             // Razón Social
          Rut_Razon_Social__c = null,            // Rut Razón Social
          Oportunidad__c = null,                 // Oportunidad
          Contrato__c = null,                    // Contrato
          Status = 'Cerrado',                    // Estado
          Origin = 'Email',                      // Origen del caso
          Priority = 'Media',                    // Prioridad
          Numero_de_Oxireport__c = null,         // Número de Oxireport
          Investigador_a_cargo__c = null,        // Investigador a cargo
          Detalle_Submotivo_Reclamo__c = null,   // Detalle Submotivo Reclamo
          Reason = null,                         // Motivo del caso
          Submotivo_del_reclamo__c = null,       // Submotivo del reclamo
          Subject = null,                        // Asunto
          Description = null,                    // Descripción
          Planta__c = null,                      // Planta
          Comments = null,                       // Comentarios internos
          Evaluacion_de_Informe__c = 'Rechaza'  // Evaluación de Informe
        );
        insert sobj; 
        
        return sobj;
    }
    
    private static List<Plazos_por_Etapa__c> crearPlazoPorEtapa(Case c){
        Datetime output = system.today();
        String todaysDaplazosListte = output.formatGmt('yyyy-MM-dd');
        Plazos_por_Etapa__c sobj = new Plazos_por_Etapa__c(
          Name = 'Investigación',                         // Nombre del Plazos por Etapa
          Caso__c = c.Id,                            // Caso
          Fecha_de_Inicio__c = Date.valueOf(todaysDaplazosListte),   // Fecha de Inicio
          Fecha_de_Termino__c = Date.valueOf(todaysDaplazosListte),  // Fecha de Termino
          D_as_Transcurridos_numero__c = null              // Días Transcurridos número
        );
        insert sobj;
        
        Plazos_por_Etapa__c sobj2 = new Plazos_por_Etapa__c(
          Name = 'Cerrado',                         // Nombre del Plazos por Etapa
          Caso__c = c.Id,                            // Caso
          Fecha_de_Inicio__c = Date.valueOf(todaysDaplazosListte),   // Fecha de Inicio
          Fecha_de_Termino__c = Date.valueOf(todaysDaplazosListte),  // Fecha de Termino
          D_as_Transcurridos_numero__c = null              // Días Transcurridos número
        );
        insert sobj2;
        
        List<Plazos_por_Etapa__c> plazosList = new List<Plazos_por_Etapa__c>();
        plazosList.add(sobj2);
        plazosList.add(sobj);
        return plazosList;
    }
}