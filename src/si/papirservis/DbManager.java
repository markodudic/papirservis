package si.papirservis;
import java.sql.SQLException;

import javax.sql.DataSource;

 
public abstract class DbManager {
	/**
	 * @param args
	 */
	public static DbManager dbManager; 

	
	public static void init(DbPoolingConfig cnf) throws Exception {
		dbManager = new C3P0DbManager(cnf);
   	}
	
	public abstract DataSource getDS();
	public abstract void destroy() throws SQLException;
	

}
