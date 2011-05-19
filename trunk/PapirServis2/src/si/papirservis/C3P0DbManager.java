package si.papirservis;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.mchange.v2.c3p0.DataSources;
import com.mchange.v2.c3p0.PooledDataSource;
 
public class C3P0DbManager extends DbManager {
	
	private DataSource ds = null;
	
	public C3P0DbManager(DbPoolingConfig cnf) throws ServletException {
		try {

			Class.forName(cnf.driver);
			// the settings below are optional -- c3p0 can work with defaults
			Map conf = new HashMap();
			conf.put("minPoolSize", cnf.minPoolSize);
			conf.put("acquireIncrement", cnf.acquireIncrement);
			conf.put("maxPoolSize", cnf.maxPoolSize);
			conf.put("preferredTestQuery", cnf.preferredTestQuery);
			
			conf.put("maxStatements", cnf.maxStatements);
			
			
			
			String serverName = cnf.host;
			String port = cnf.port;
	        String mydatabase = cnf.database;
	        String url = cnf.url == null ? "jdbc:mysql://" + serverName +  ":"+port+"/" + mydatabase : cnf.url; // a JDBC url
	        String username = cnf.username;
	        String password = cnf.password;
	        
			DataSource ds_unpooled = DataSources.unpooledDataSource(url, username, password);
			ds = DataSources.pooledDataSource( ds_unpooled, conf );
			
			Connection con = ds.getConnection();
			
			con.close();
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new ServletException("Problem pri povezavi na bazo.");
		}
	}
	
	public DataSource getDS() {
		return ds;
	}
	
	public void destroy() throws SQLException
	{
		try
		{
		// do all kinds of stuff with that sweet pooled DataSource...
		}
		finally
		{
		DataSources.destroy( ds );
		}
	}
	
	public String toString() {
		//		 make sure it's a c3p0 PooledDataSource
		try {
			if ( ds instanceof PooledDataSource)
			{
			PooledDataSource pds = (PooledDataSource) ds;
			System.err.println("num_connections: " + pds.getNumConnectionsDefaultUser());
			System.err.println("num_busy_connections: " + pds.getNumBusyConnectionsDefaultUser());
			System.err.println("num_idle_connections: " + pds.getNumIdleConnectionsDefaultUser());
			System.err.println();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}
