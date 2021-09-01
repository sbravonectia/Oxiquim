global class OXIQUIM_Crearprograma_Automatico {
        
    @InvocableMethod
    public static void crea_programa(List<Opportunity> opp) {
        
        system.debug('opp'+opp); 
        system.debug('Cantidad_de_Meses__c'+opp[0].Cantidad_de_Meses__c);
       integer meses;
        if(opp[0].Cantidad_de_Meses__c==null){
           meses=0;  
        }else{
            meses=integer.valueOf(opp[0].Cantidad_de_Meses__c);   
        }
        //  crear_pedido_SAP(idopp[0]);
        list<OpportunityLineItem> oppl=[  SELECT Id, name,TotalPrice FROM OpportunityLineItem where OpportunityId =:opp[0].id ];
        list<OpportunityLineItemSchedule> listopp_LineItemS=new list<OpportunityLineItemSchedule>();
        list<string> list_OpportunityLineItem=new list<string>();
         for(OpportunityLineItem opl:oppl){
            list_OpportunityLineItem.add(opl.id);
        }
          list<OpportunityLineItemSchedule> oppItems=[SELECT Id FROM OpportunityLineItemSchedule where OpportunityLineItemId in: list_OpportunityLineItem ];
         delete oppItems;
         
 
        system.debug('oppl'+oppl);
      date fecha_pago;
        for(OpportunityLineItem opl:oppl){
               fecha_pago=system.today();
            for(integer i=0;i<opp[0].Cantidad_de_Meses__c;i++){
                
                OpportunityLineItemSchedule opplineS=new OpportunityLineItemSchedule();
                opplineS.OpportunityLineItemId=opl.id;
                opplineS.type='Revenue';
                opplineS.ScheduleDate=fecha_pago;
                //opplineS.CurrencyIsoCode='CLP';
                opplineS.Revenue=opl.TotalPrice/meses;
                //opplineS.Quantity=1;
                system.debug('opplineS'+opplineS); 
                listopp_LineItemS.add(opplineS);
                 fecha_pago=fecha_pago.addMonths(1);
            }
        }
        system.debug('listopp_LineItemS'+listopp_LineItemS);
        insert listopp_LineItemS;  
    }
    
}