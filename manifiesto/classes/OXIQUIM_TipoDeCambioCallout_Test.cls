@isTest
private class OXIQUIM_TipoDeCambioCallout_Test {

    @isTest static void testCalloutWithStaticResources() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ZRFC_WS_TIPOCAMBIOResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/xml');
        
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new OXIQUIM_tipoDeCambio_Schedulable());
        Test.stopTest();       
    }  
}