package si.papirservis;

import java.io.File;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;



public class MultipartUpload {
	private static Log log = LogFactory.getLog(MultipartUpload.class);
	public Properties params = new Properties(); // derived
	public Map<String,File> files = new LinkedHashMap<String,File>(); // derived

	
	public MultipartUpload decode(HttpServletRequest request, HttpServletResponse response, int max_file_size, String fileDir) throws Exception{
		try {
			log.debug("upload decode");
			log.debug("fileDir:"+fileDir);
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			log.debug("isMultipart:"+isMultipart);
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(1); // from this file sizes (B) uploads are in temp file, less in memory
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(max_file_size); // throws error if bigger
			List /* FileItem */ items = upload.parseRequest(request);
			Iterator iter = items.iterator();
			String fex;
			while (iter.hasNext()) {
				Object u = iter.next();
			    FileItem item = (FileItem) u;
			    if (item.isFormField()) {
			    	String name = item.getFieldName();
			        String value = item.getString();
			        value = new String(value.getBytes("iso8859-1"), "utf-8");
			        params.setProperty(name, value);
			    } else {
			        //File f = new File(fileDir+item.getName());
			    	//fex = FilenameUtils.getExtension(item.getName());
			    	File f = new File(fileDir+item.getName());
			    	f.getParentFile().mkdirs();
			        log.debug(f);
			        StreamUtil.inputStreamToFile(item.getInputStream(),f);
			        files.put(item.getName(), f);
			    }
			}
			return this;
		} catch (Exception e) {
			throw e;
		}
	}
	
}
