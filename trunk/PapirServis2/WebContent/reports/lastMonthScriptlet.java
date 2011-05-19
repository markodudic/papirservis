import net.sf.jasperreports.engine.*;

public class lastMonthScriptlet extends net.sf.jasperreports.engine.JRDefaultScriptlet {


	
	public Long lastMonth = new java.lang.Long(0);
	public Long lastCust = new java.lang.Long(0);
    
	/** Creates a new instance of JRIreportDefaultScriptlet */
	public lastMonthScriptlet() {
    
	}

	public Long getLastMonth(Long nextMonth) throws JRScriptletException
	{
	  Long i = lastMonth;
	  lastMonth = nextMonth;

	  return i;
	}

	public Long getLastCust(Long nextCust) throws JRScriptletException
	{
	  Long i = lastCust;
	  lastCust = nextCust;

	  return i;
	}

	public void afterColumnInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void afterDetailEval() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void afterGroupInit(String arg0) throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void afterPageInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void afterReportInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void beforeColumnInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void beforeDetailEval() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void beforeGroupInit(String arg0) throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void beforePageInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}

	public void beforeReportInit() throws JRScriptletException {
		// TODO Auto-generated method stub
		
	}


}