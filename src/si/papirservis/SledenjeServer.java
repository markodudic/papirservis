package si.papirservis;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Vector;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/*
 * Servlet za poizvedbo podatkov o voznjah za podjetje Papir Servis
 * Servlet sprejme podatke o dobavnicah in lokacijah,
 * vrne pa podatke o opravljenih poteh in casu.
 */
public class SledenjeServer extends HttpServlet implements Servlet {
 
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public SledenjeServer() {
		super();
	}

	
	protected void doGet(HttpServletRequest arg0, HttpServletResponse arg1) 	throws ServletException, IOException {
		System.out.println("SledenjeServer GET"); 
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		System.out.println("SledenjeServer START"); 
		try {
	            //get request data
				//datum - datum za poizvedbo
				//data - vector podatkov v obliki
				//[[sifra, stranka_sifra, stranka_naziv, lokacija_x, lokacija_y, lokacija_radij, lokacija_vtez, enota_x, enota_y, enota_radij, kamion_registrska]]
				ObjectInputStream in = new ObjectInputStream(request.getInputStream());
	            ObjectOutputStream out = new ObjectOutputStream(response.getOutputStream());

				Object o = null;
				o = in.readObject();
				String datum = o.toString();
				o = in.readObject();
				Vector data = (Vector) o;
	            
	            System.out.println("datum: " + datum);
	            System.out.println("data: " + data);
	            
	            //get data from sledenje server
	            //podatki so v obliki
	            //[[sifra, pot, cas]]
	            //dummy data
	            Vector result = new Vector(3);
	            result.add("22222");
	            result.add("2222");
	            
	            //send results to the papirservis server
	            out.writeObject(result);

	            in.close();
	            out.close();
	            
	    		System.out.println("SledenjeServer END"); 


	        } catch (Exception e) {
	            System.out.println(e.toString());
	            e.printStackTrace();
	        }

	}

	  
}
