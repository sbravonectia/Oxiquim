global class OXIQUIM_TipoDeCambioCallout {	
    
    @Future(Callout=true)
	public static void ZRFC_WS_TIPOCAMBIO_Callout() {
        Servicio_Web__mdt mdt = [select Usuario__c,Contrasena__c, endpoint__c from Servicio_Web__mdt WHERE DeveloperName = 'Tipo_de_Cambio_QA'];
        Blob headerValue = Blob.valueOf(mdt.Usuario__c + ':' + mdt.Contrasena__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);    
        Http h = new Http();    
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse(); 
        req.setEndpoint(mdt.endpoint__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('Authorization', authorizationHeader); 
		try{    
			req.setBody(OXIQUIM_tipoDeCambioCallout.request());
            //if(!Test.isRunningTest())
				res = h.send(req);
			if(res.getStatusCode() == 200){
					System.debug('Respuesta: '+res.getBody());
					OXIQUIM_tipoDeCambioCallout.parseResponseDom(res);
			}else{
				System.debug('Error: '+res.getBody());
			}
		}catch(Exception e){
			System.debug('Exception: '+e.getMessage());
			OXIQUIM_tipoDeCambioCallout.enviarCorreoError(e);
		}
	}
    
    public static String request(){
        String currency1 = 'USD';
        String currency2 = 'EUR';
        String currency3 = 'UF';
		Datetime output = system.today();
		String todaysDate = output.formatGmt('dd.MM.yyyy');
        String xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">'+
                       '<soapenv:Header/>'+
                       '<soapenv:Body>'+
                          '<urn:ZRFC_WS_TIPOCAMBIO>'+
                            '<I_DATE>'+todaysDate+'</I_DATE>'+
                             '<I_MONEDA>'+            
                                '<item>'+
                                   '<FCURR>'+currency1+'</FCURR>'+
                                 '</item>'+
                                 '<item>'+
                                   '<FCURR>'+currency2+'</FCURR>'+
                                '</item>'+
                                 '<item>'+
                                   '<FCURR>'+currency3+'</FCURR>'+
                                '</item>'+
                             '</I_MONEDA>' +
                             '<O_RESPONSE>' +           
                             '</O_RESPONSE>' +
                          '</urn:ZRFC_WS_TIPOCAMBIO>'+
                       '</soapenv:Body>'+
                    '</soapenv:Envelope>';
		System.debug('XML Request: '+xml);
        return xml;
    }
    
    public static void parseResponseDom(HttpResponse res){
        Map<String,Decimal> tipoDeCambioMap = new Map<String,Decimal>();
        Dom.Document doc = res.getBodyDocument();        
        //Retrieve the root element for this document.
        Dom.XMLNode envelope = doc.getRootElement();
        System.debug('envelope: ' + envelope);
        Dom.XMLNode Body = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
        System.debug('Body: ' + Body);
        Dom.XMLNode ZRFC_WS_TIPOCAMBIOResponse = Body.getChildElement('ZRFC_WS_TIPOCAMBIOResponse', 'urn:sap-com:document:sap:rfc:functions');
        System.debug('ZRFC_WS_TIPOCAMBIOResponse: ' + ZRFC_WS_TIPOCAMBIOResponse);
        Dom.XMLNode O_RESPONSE = ZRFC_WS_TIPOCAMBIOResponse.getChildElement('O_RESPONSE', null);
        System.debug('O_RESPONSE: ' + O_RESPONSE);        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode item : O_RESPONSE.getChildElements()) {
          system.debug( item.getName() + '-' + item.getText() );
          String tipoMoneda = '';
          Decimal tcambio = 0;
            for ( Dom.XMLNode detailElement : item.getChildElements() ){
        		system.debug( detailElement.getName() + '-' + detailElement.getText() );           
            	if(detailElement.getName() == 'FCURR')
                    tipoMoneda = detailElement.getText();
                if(detailElement.getName() == 'UKURS')
                    tcambio = Decimal.valueOf(detailElement.getText());
                
                tipoDeCambioMap.put(tipoMoneda,tcambio);                    
            }    
        }
        System.debug('tipoDeCambioMap: ' + tipoDeCambioMap);
        OXIQUIM_tipoDeCambioCallout.currencyTypeCallout(tipoDeCambioMap);
    }
    
    public static void currencyTypeCallout(Map<String,Decimal> tipoDeCambioMap){ 
		if(tipoDeCambioMap.get('USD')!= null)     
			OXIQUIM_tipoDeCambioCallout.currencyTypeUSDCallout(tipoDeCambioMap);
		if(tipoDeCambioMap.get('EUR')!= null)
			OXIQUIM_tipoDeCambioCallout.currencyTypeEURCallout(tipoDeCambioMap);
		if(tipoDeCambioMap.get('UF')!= null)
			OXIQUIM_tipoDeCambioCallout.currencyTypeCLFCallout(tipoDeCambioMap);      
    }

	public static void currencyTypeUSDCallout(Map<String,Decimal> tipoDeCambioMap){
		Http h2 = new Http();
        HttpRequest req2 = new HttpRequest();
        Datetime output = system.today();
		Decimal usdConversionRate = tipoDeCambioMap.get('USD');
        String todaysDateStr2 = output.formatGmt('yyyy-MM-dd');
        req2.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/sobjects/DatedConversionRate/');           
        req2.setMethod('POST');        
        req2.setBody('{ "IsoCode" : "USD", "ConversionRate" : '+usdConversionRate+', "StartDate" : "'+todaysDateStr2+'" }');       
        req2.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());       
        req2.setHeader('Content-Type', 'application/json');
        System.debug('Request Body 2:'+req2.getBody());
        HttpResponse res2 = h2.send(req2);
	}

	public static void currencyTypeEURCallout(Map<String,Decimal> tipoDeCambioMap){
		Http h = new Http();
        HttpRequest req = new HttpRequest();
        Datetime output = system.today();
		Decimal eurConversionRate = tipoDeCambioMap.get('EUR');
        String todaysDateStr = output.formatGmt('yyyy-MM-dd');
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/sobjects/DatedConversionRate/');           
        req.setMethod('POST');        
        req.setBody('{ "IsoCode" : "EUR", "ConversionRate" : '+eurConversionRate+', "StartDate" : "'+todaysDateStr+'" }');       
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());       
        req.setHeader('Content-Type', 'application/json');
        System.debug('Request Body:'+req.getBody());
        HttpResponse res = h.send(req);
	}	

	public static void currencyTypeCLFCallout(Map<String,Decimal> tipoDeCambioMap){
		Http h3 = new Http();
        HttpRequest req3 = new HttpRequest();
        Datetime output = system.today();
        String todaysDateStr3 = output.formatGmt('yyyy-MM-dd');
		Decimal CLFConversionRate = tipoDeCambioMap.get('UF')*100;
        req3.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v52.0/sobjects/DatedConversionRate/');           
        req3.setMethod('POST');        
        req3.setBody('{ "IsoCode" : "CLF", "ConversionRate" : '+CLFConversionRate+', "StartDate" : "'+todaysDateStr3+'" }');       
        req3.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());       
        req3.setHeader('Content-Type', 'application/json');
        System.debug('Request Body 3:'+req3.getBody());
        HttpResponse res3 = h3.send(req3);
	}

	public static void enviarCorreoError(Exception e){
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		String userId = UserInfo.getUserId();
		User activeUser = [Select Email From User where Id = : userId and IsActive=true limit 1];
		String userEmail = activeUser.Email;
		message.toAddresses = new String[] { userEmail };
		message.optOutPolicy = 'FILTER';
		message.subject = 'CRM Salesforce | Problema con integración para tipo de cambio.';
		message.htmlBody = 'Problema: '+e.getMessage()+ ' | ' + 'Línea: '+ e.getLineNumber();
		Messaging.SingleEmailMessage[] messages = 
			new List<Messaging.SingleEmailMessage> {message};
				 Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
		if (results[0].success) {
			System.debug('The email was sent successfully.');
		} else {
			System.debug('The email failed to send: '
				  + results[0].errors[0].message);
		}
	}
    
}