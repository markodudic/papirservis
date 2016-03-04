package si.papirservis;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map.Entry;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ArsoPosiljanjeServlet extends InitServlet implements Servlet {

	Locale locale = Locale.getDefault();
	 
	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public ArsoPosiljanjeServlet() {
		super();
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("SERVLET GET");	
		doPost(request, response);
	}

	/*
	 * (non-Java-doc)
	 * 
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest arg0,
	 *      HttpServletResponse arg1)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String tempDir = this.getServletContext().getRealPath("/") + "arso/";
		String zipName = "evl_"+ (new Date()).getTime() + ".zip";
        
		System.out.println("uploadFile="+tempDir);
		FileOutputStream fos = new FileOutputStream(tempDir+"/" +zipName);
		ZipOutputStream zos = new ZipOutputStream(fos);
		OutputStream os = response.getOutputStream();
		byte[] buffer = new byte[1024];
		
		try {
			MultipartUpload mu = new MultipartUpload().decode(request, response, 20000000, tempDir+"/");
			System.out.println(mu.files);
			
			
			ArsoPDFParser arso = new ArsoPDFParser(tempDir);
			
			List<String> maticnaList = new ArrayList<String>();
					
			for (Entry<String, File> fEntry : mu.files.entrySet()) {
				maticnaList = arso.loadSavePDF(fEntry.getValue(), fEntry.getKey().replace(".pdf", ""));
				
				for (int i=1; i < maticnaList.size(); i++) {
				  String maticna = maticnaList.get(i);
				  FileInputStream fin = new FileInputStream(maticna);
			      try {
			        System.out.println("Compressing " + maticna.substring(maticna.indexOf("/")+1));
			        zos.putNextEntry(new ZipEntry(maticna.substring(maticna.indexOf("/")+1)));
		    		int len;
		    		while ((len = fin.read(buffer)) > 0) {
		    			zos.write(buffer, 0, len);
		    		}

			      } finally {
			        fin.close();
			      }
				}
			}
		    zos.closeEntry();
		    zos.flush();
			zos.close();
			
			/*response.setContentType("application/zip");
			response.addHeader("Content-Disposition", "attachment; filename=evl.zip");
			
			FileInputStream fis = new FileInputStream(System.getProperty("java.io.tmpdir")+"/evl.zip"); 
			int bytes;
			while ((bytes = fis.read()) != -1) {
				os.write(bytes);
			}
			fis.close();*/
			os.write((maticnaList.get(0)+"|"+"/arso/"+zipName).getBytes("utf-8"));
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		finally {
			os.flush();
			os.close();
		}


	}
}
