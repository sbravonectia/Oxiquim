global class OXIQUIM_TipoDeCambio_Schedulable implements Schedulable {
	/**
	 * @description Executes the scheduled Apex job. 
	 * @param sc contains the job ID
	 */ 
	global void execute(SchedulableContext sc) {
		OXIQUIM_tipoDeCambioCallout.ZRFC_WS_TIPOCAMBIO_Callout();
	}
}