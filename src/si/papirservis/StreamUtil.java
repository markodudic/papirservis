package si.papirservis;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

public class StreamUtil {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	
	public static byte[] getBytesFromFile(File file) throws IOException {
        InputStream is = new FileInputStream(file);
    
        // Get the size of the file
        long length = file.length();
    
        // You cannot create an array using a long type.
        // It needs to be an int type.
        // Before converting to an int type, check
        // to ensure that file is not larger than Integer.MAX_VALUE.
        if (length > Integer.MAX_VALUE) {
            // File is too large
        }
    
        // Create the byte array to hold the data
        byte[] bytes = new byte[(int)length];
    
        // Read in the bytes
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
               && (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
            offset += numRead;
        }
    
        // Ensure all the bytes have been read in
        if (offset < bytes.length) {
            throw new IOException("Could not completely read file "+file.getName());
        }
    
        // Close the input stream and return bytes
        is.close();
        return bytes;
    }
	
	public static void inputStreamToFile(InputStream is, File file) throws Exception {
		try {
			OutputStream out=new FileOutputStream(file);
			byte buf[]=new byte[1024];
			int len;
			while((len=is.read(buf))>0) {
				out.write(buf,0,len);
			}
			out.flush();
			out.close();
			is.close();
	    }
	    catch (IOException e){}
	}
	
	public static void ungzipFile(File fin, File fout) throws Exception {
		GZIPInputStream gzipInputStream = null;
		gzipInputStream = new GZIPInputStream(new FileInputStream(fin));
		OutputStream out = new FileOutputStream(fout);

		byte[] buf = new byte[1024];  //size can be 
		int len;
		while ((len = gzipInputStream.read(buf)) > 0) {
			out.write(buf, 0, len);
		}
	    gzipInputStream.close();
	    out.close();
	}
	public static void gzipFile(File fin, File fout) throws IOException {
		GZIPOutputStream out = new GZIPOutputStream(new FileOutputStream(fout)); 
		FileInputStream in = new FileInputStream(fin); 
		byte[] buf = new byte[1024]; 
		int len; 
		while ((len = in.read(buf)) > 0) { 
			out.write(buf, 0, len); 
		} 
		in.close();
		out.finish(); 
		out.close(); 
	}
	public static String stringFromFile(String strFile,String charset) {
	       File file = new File(strFile);
	       URI uri = file.toURI();
	       byte[] bytes = null;
	       try{
	          bytes = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(uri));
	       }catch(IOException e) { e.printStackTrace(); return "ERROR loading file "+strFile; }
	    
	       try {
	    	   return new String(bytes,charset);
			} catch (UnsupportedEncodingException e) {
				return new String(bytes);
			}
	    }


}
