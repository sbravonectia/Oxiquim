@isTest
public class Oxiquim_Crearprograma_Automatico_Test {
	@isTest static void test() {
        Oxiquim_Crearprograma_Automatico.crea_programa(crearOportundidad());
    }  
  
    private static List<Opportunity> crearOportundidad(){
        List<Opportunity> oppList = new List<Opportunity>();
        Datetime output = system.today();
        String todaysDaplazosListte = output.formatGmt('yyyy-MM-dd');        
        Pricebook2 listaPrecios = crearPricebook2();
        Product2 prod = crearProduct2();
        crearPriceBookEntry(prod,listaPrecios);
        Account acc = crearCuenta();
        Opportunity sobj = new Opportunity(
          Name = 'Opp',
          Description = 'Reemplazar pasta de retape de Tapel por pasta Oxifill RM75 en líneas de Tulsa',// Descripción de la oportunidad
          CloseDate = Date.valueOf(todaysDaplazosListte),                                                          // Fecha de cierre
          AccountId = acc.Id,                                                                        // Razón Social
          Unidad_de_Negocios__c = null,                                                              // Unidad de Negocios
          StageName = 'Propuesta Entregada',                                                              // Etapa de la oportunidad
          Centro_Logistico__c = '1061',                                                                   // Centro Logístico
          Probability = 60,                                                                               // Probabilidad (%)
          Condicion_de_venta__c = 'Entregado en cliente',                                                 // Condición de venta
          Amount = 5.00000,                                                                               // Venta Neta Esperada
          CurrencyIsoCode = 'USD',                                                      // Divisa de la oportunidad
          Type = 'Venta Recurrente',                                                                      // Tipo de Venta
          Tipo_de_Negocio__c = 'Nacional',                                                                // Tipo de Negocio
          Direccion_de_Entrega__c = null,                                                                 // Dirección de Entrega
          Comuna_de_Entrega__c = 'Coronel',                                                               // Comuna de Entrega
          Ciudad_de_Entrega__c = 'Coronel',                                                               // Ciudad de Entrega
          Region_de_Entrega__c = 'Región del Biobío',                                                     // Región de Entrega
          Cantidad_de_Meses__c = 12,                                                                    // Cantidad de Meses
          Pais_de_Entrega__c = 'Chile',                                                                   // País de Entrega
          Budget_Confirmed__c = false,                                                                    // Presupuesto confirmado
          Discovery_Completed__c = false,                                                                 // Descubrimiento completo
          ROI_Analysis_Completed__c = false,                                                              // Análisis de ROI completado
          Loss_Reason__c = null,                                                                          // Razón de pérdida
          Comentarios_sobre_razon_de_perdida__c = null,                                                   // Comentarios sobre razón de pérdida
          Pricebook2Id =  Test.getStandardPricebookId()
        );
        insert sobj;
        crearOpportunityLineItemSchedule(crearOportunityLineItem(sobj,prod));
        oppList.add(sobj);
        
        return oppList;
    }
    
    private static OpportunityLineItem crearOportunityLineItem(Opportunity opp,Product2 p){
        OpportunityLineItem oppLineTime = new OpportunityLineItem();
        oppLineTime.OpportunityId = opp.Id;
        oppLineTime.Product2Id = p.Id;
        oppLineTime.Quantity = 1;
        oppLineTime.UnitPrice = 1000;
        
        insert oppLineTime;
        return oppLineTime;
    }
    
    private static void crearOpportunityLineItemSchedule(OpportunityLineItem oppLI){
        OpportunityLineItemSchedule oppLIS = new OpportunityLineItemSchedule();
        oppLIS.OpportunityLineItemId = oppLI.Id; 
        oppLIS.type='Revenue';
        oppLIS.ScheduleDate=system.today();
        oppLIS.Revenue = 1000;
        insert oppLIS;
    }
    
    private static Pricebook2 crearPricebook2(){
        Pricebook2 p = new Pricebook2();
        p.Name = 'Lista de Precios';
        p.IsActive = true;
		//p.IsStandard = true;
        insert p;
        return p;
    }
    
    private static Product2 crearProduct2(){
        Product2 p = new Product2();
        p.Name = 'Producto';
        p.IsActive = true;
        p.Family = 'Acetato';
        //p.StockKeepingUnit
        p.Unidad_de_Medida__c = 'KG';
        p.Peligrosidad__c = '8-1779';
        p.CanUseRevenueSchedule = true;
        insert p;
        return p;
    }
    
    private static void crearPriceBookEntry(Product2 prod,Pricebook2 listaPrecios){
        PricebookEntry p = new PricebookEntry();
        p.Product2Id = prod.Id;
        p.Pricebook2Id = Test.getStandardPricebookId();    
        p.UnitPrice = 1000; 
        p.IsActive = true;
        p.CurrencyIsoCode = 'USD';

        insert p;
        
        /*PricebookEntry pbe = new PricebookEntry(Pricebook2Id = listaPrecios.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;*/
            
    }
    
    private static Account crearCuenta(){
        Account sobj = new Account(
          Name = 'Tulsa S.A.',                   // Razón Social
          RUT_Razon_Social__c = '96664360-9',      // RUT Razón Social
          ParentId = null,                         // Matriz
          Giro__c = 'Fabricación de Tableros',     // Giro
          CodigoSAP__c = null,                     // Código SAP
          Website = null,                          // Sitio Web
          Mensaje_de_Error__c = null,              // Mensaje de Error
          C_digo_de_Error__c = null,               // Código de Error
          CurrencyIsoCode = 'USD',  // Moneda de la cuenta
          Actividad_Industrial__c = null,          // Actividad Industrial
          Ownership = 'Privada',                   // Propiedad
          AnnualRevenue = null,                    // Ingresos anuales
          Descripci_n__c = null,                   // Descripción
          NumberOfEmployees = null,                // Empleados
          Oficina_Depto_Otro__c = null            // Oficina/Depto./Otro
        );
        insert sobj;
        
        return sobj;
    }
}