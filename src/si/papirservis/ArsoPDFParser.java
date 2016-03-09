package si.papirservis;

import java.awt.Color;
import java.awt.Rectangle;
import java.awt.geom.AffineTransform;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.StringWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.multipdf.LayerUtility;
import org.apache.pdfbox.multipdf.PDFMergerUtility;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.PDPageTree;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.graphics.form.PDFormXObject;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import org.apache.pdfbox.text.TextPosition;



public class ArsoPDFParser extends PDFTextStripperByArea {

	public static StringBuilder tWord = new StringBuilder();
	public static String[] seek;
	public static List wordList = new ArrayList();
	public static boolean is1stChar = true;
	public static boolean lineMatch;
	public static int pageNo = 0;
	public static double lastYVal;
	public static List<String> maticneList = new ArrayList();
		
	public static String dir;
	
	public ArsoPDFParser(String dir) throws IOException {
		super.setSortByPosition(true);
		ArsoPDFParser.dir = dir;
	}

	public static void main(String[] args) throws Exception {
		dir = "C:/Projects/Monolit/pdfbox/doc/";
		String fileName = "3372"; //3179
		File file = new File(dir+fileName+".pdf");
		loadSavePDF(file, fileName);
	}
	
	public static List<String> loadSavePDF(File pFile, final String fileName) throws Exception {
		boolean ret = false;
		PDDocument  pdDocument = null;
		List<String> maticnaList = new ArrayList<String>();
        		
		try {

			pdDocument = PDDocument.load(pFile);
			
			File path = new File(pFile.getParent());
			
			PDPageTree pages = pdDocument.getDocumentCatalog().getPages();
	        PDPage p = (PDPage)pages.get( 0 ); 
            int offset = 20;
            int offsetmaticna = 18;
            int header = 63;
            int endOfContent = 800;
            maticneList.clear();

            //ARSO paket
     	
        	
	        int xPaket = 315;
            int yPaket = 160;
            Rectangle rect = new Rectangle( xPaket, yPaket, 50, 60 ); 
            PDFTextStripperByArea stripper = new PDFTextStripperByArea(); 
            stripper.setSortByPosition( true ); 
            stripper.addRegion( "class", rect ); 
            stripper.extractRegions( p ); 
            System.out.println( "***********ARSO paket***************" );
            System.out.println( stripper.getTextForRegion( "class" ).trim() );
            String paket = stripper.getTextForRegion( "class" ).trim();
            stripper.removeRegion("class");
            maticnaList.add(paket);
            
            //PDDocument outputDoc = new PDDocument();
            PDDocument outputDoc1 = new PDDocument();
	        PDRectangle rectangle = new PDRectangle();
	        File filenameSign = null;
	        File filename = null;
			
            //EVIDENCNI LOCATIONS
	        wordList = new ArrayList();
            String str = "Evidenčni,Digitalni";
            seek = str.split(",");
            ArsoPDFParser printer = new ArsoPDFParser(dir);
            
            pageNo = 0;
            for (int i = 0; i < pages.getCount(); i++) {
                pageNo += 1;
            	PDPage page = (PDPage) pages.get(i);
            	
            	printer.processPage(page);
            	
            	StringWriter dummy = new StringWriter();
            	printer.setStartPage(pageNo);
            	printer.setEndPage(pageNo);
            	printer.writeText(pdDocument, dummy);
            	
            }
            System.out.println(wordList);
        	List evidenciList = wordList;
        	List evidenciListFull = new ArrayList<String>();
        	evidenciListFull.add(evidenciList.get(0));
        	
        	int prevPage = 1;
        	for (int i=1; i<evidenciList.size()-1; i++) {
        		boolean endOnOtherPage = true;
        		String curr = (String)evidenciList.get(i);
        		if (prevPage != Integer.parseInt(curr.split("_")[0])) {
        			evidenciListFull.add(prevPage+"_"+endOfContent+"_"+seek[0]);
        			evidenciListFull.add(curr);
        			endOnOtherPage = false;
        		}
        		else {
        			evidenciListFull.add(curr);
        		}
        		
        		String next = (String)evidenciList.get(i+1);
        		String[] nextSplit = next.split("_");
        		prevPage = Integer.parseInt(nextSplit[0]);
        		String in = nextSplit[0]+"_"+header+"_"+seek[0];
        		evidenciListFull.add(in);
       		
        		if (endOnOtherPage) {
        			i++;
        			evidenciListFull.add(evidenciList.get(i));
        		}
        	}
            System.out.println(evidenciListFull);
            evidenciList = evidenciListFull;
            
            
            //SIGN LOCATION
            str = "Digitalni";
            seek = str.split(",");
            wordList = new ArrayList();
            
            printer = new ArsoPDFParser(dir);
        	pageNo = pages.getCount();
        	PDPage page = (PDPage) pages.get(pageNo-1);
        	
        	printer.processPage(page);
        	
        	StringWriter dummy = new StringWriter();
        	printer.setStartPage(pageNo);
        	printer.setEndPage(pageNo);
        	printer.writeText(pdDocument, dummy);
        
        	//ce je podpis na dveh straneh
        	boolean signLatsPage = true;
        
        	System.out.println(wordList);
        	if (wordList.size() == 0) {
            	page = (PDPage) pages.get(pageNo-2);
            	
            	printer.processPage(page);
            	
            	dummy = new StringWriter();
            	printer.setStartPage(pageNo);
            	printer.setEndPage(pageNo);
            	printer.writeText(pdDocument, dummy);
            
            	signLatsPage = false;
            	System.out.println(wordList);
        	}
        	
        	String[] sign = ((String)wordList.get(0)).split("_");
            
            //SIGN PDF
        	int ps = Integer.parseInt(sign[0]);
        	int start = Integer.parseInt(sign[1]);
        	int end = 0;
        	int len = 155;
	        PDPage pageSignClone;
	        if (signLatsPage) {
	        	pageSignClone = pages.get(ps-1);
	        }
	        else {
	        	pageSignClone = pages.get(ps-2);
	        }
    		COSDictionary pageDict = pageSignClone.getCOSObject();
    		COSDictionary newPageDict = new COSDictionary(pageDict);
    		newPageDict.removeItem(COSName.ANNOTS);
    		PDPage pageSign = new PDPage(newPageDict);
            double pHeight = pageSign.getMediaBox().getHeight();
            double pWidth = pageSign.getMediaBox().getWidth();
            rectangle = new PDRectangle();
            rectangle.setUpperRightY((int)pHeight - start + 10);
            if (signLatsPage) {
                rectangle.setLowerLeftY((int)pHeight - start - len);
            }
            else {
                rectangle.setLowerLeftY(55);            	
            }
            rectangle.setUpperRightX(0);
            rectangle.setLowerLeftX((int)pWidth);                  
            pageSign.setCropBox(rectangle);
            outputDoc1.addPage(pageSign);
            filenameSign = new File(path+"/"+pFile.getName().substring(0,pFile.getName().lastIndexOf("."))+"_sign"+".pdf");
			outputDoc1.save(filenameSign);              
            outputDoc1.close();
            
            if (!signLatsPage) {
            	outputDoc1 = new PDDocument();
		        pageSignClone = pages.get(ps-1);
	    		pageDict = pageSignClone.getCOSObject();
	    		newPageDict = new COSDictionary(pageDict);
	    		newPageDict.removeItem(COSName.ANNOTS);
	    		pageSign = new PDPage(newPageDict);
	            rectangle = new PDRectangle();
	            rectangle.setUpperRightY((int)pHeight - 55);
	            rectangle.setLowerLeftY((int)pHeight - 200);
	            rectangle.setUpperRightX(0);
	            rectangle.setLowerLeftX((int)pWidth);                  
	            pageSign.setCropBox(rectangle);
	            outputDoc1.addPage(pageSign);
	            File filenameSign1 = new File(path+"/"+pFile.getName().substring(0,pFile.getName().lastIndexOf("."))+"_sign1"+".pdf");
				outputDoc1.save(filenameSign1);              
	            outputDoc1.close();
	            
	            generateSideBySidePDF(filenameSign, filenameSign1, 650, 200, 0, false); //todo
	            filenameSign = filenameSign1;
            }            
            
            //RAZREŽEM PO LISTIH
        	for (int i=0; i<evidenciList.size()-1; i++) {
        		String[] evidenciCurr = ((String)evidenciList.get(i)).split("_");
        		ps = Integer.parseInt(evidenciCurr[0]);
        		start = Integer.parseInt(evidenciCurr[1]);
        		
        		boolean twoSide=false;
        		//CE JE ZADNJI V LISTI
        		if (i<evidenciList.size()-1) {
        			String[] evidenciNext = ((String)evidenciList.get(i+1)).split("_");
        			//CE JE NA DVEH STRANEH
            		if (ps == Integer.parseInt(evidenciNext[0])) {	
            			end = Integer.parseInt(evidenciNext[1]);
            		}
            		else {
            			twoSide = true;
            			end = endOfContent;
            		}
        		}
        		else {
        			end = 0;
        		}
        		
        		float expand = start - 10;
        		
        		PDPage pageClone = pages.get(ps-1);
        		COSDictionary pageDict1 = pageClone.getCOSObject();
        		COSDictionary newPageDict1 = new COSDictionary(pageDict1);
        		newPageDict1.removeItem(COSName.ANNOTS);
        		PDPage pageCurr = new PDPage(newPageDict1);
                pHeight = pageCurr.getMediaBox().getHeight();
                pWidth = pageCurr.getMediaBox().getWidth();
                
            	PDRectangle cropBox = pageCurr.getCropBox();
                PDRectangle newCropBox = new PDRectangle();
                newCropBox.setLowerLeftX(cropBox.getLowerLeftX());
                newCropBox.setLowerLeftY(cropBox.getLowerLeftY() - expand);
                newCropBox.setUpperRightX(cropBox.getUpperRightX());
                newCropBox.setUpperRightY(cropBox.getUpperRightY() - expand);
                pageCurr.setCropBox(newCropBox);

                PDRectangle mediaBox = pageCurr.getMediaBox();
                PDRectangle newMediaBox = new PDRectangle();
                newMediaBox.setLowerLeftX(mediaBox.getLowerLeftX());
                newMediaBox.setLowerLeftY(mediaBox.getLowerLeftY() - expand);
                newMediaBox.setUpperRightX(mediaBox.getUpperRightX());
                newMediaBox.setUpperRightY(mediaBox.getUpperRightY() - expand);
                pageCurr.setMediaBox(newMediaBox);
                
                PDPageContentStream pageCS = null;
                pageCS = new PDPageContentStream(pdDocument, pageCurr, true, false);
	            pageCS.setNonStrokingColor(Color.white);
	            pageCS.fillRect(0, 0, (int)pWidth, (int)pHeight - end + 10);
	            pageCS.close();

	        	outputDoc1 = new PDDocument();
                outputDoc1.addPage(pageCurr);

                filename = new File(path+"/"+pFile.getName().substring(0,pFile.getName().lastIndexOf("."))+"_"+i+".pdf");
    			outputDoc1.save(filename);              
                outputDoc1.close();

                
                //ce je evl na dveh listih
            	File filename1 = new File(path+"/"+pFile.getName().substring(0,pFile.getName().lastIndexOf("."))+"_"+(i-1)+".pdf");
                if ((i+1) % 3 == 0) {
                    int koef = 40;
                    String[] evidenciPrev = ((String)evidenciList.get(i-1)).split("_");
                    generateSideBySidePDF(filename1, filename, (int)pHeight - Integer.parseInt(evidenciPrev[1]) + koef, 0, i, false);
                }

                if ((i+2) % 3 != 0) {
                	int signLocation = 600;
                	if (!signLatsPage) {
                		signLocation -= 500;
                	}
                	generateSideBySidePDF(filename, filenameSign, signLocation, 0, i, true);
                }
                
                filename1.delete();
        	}
            filename.delete();
            filenameSign.delete();
            
            //merge files 
            for (final String maticna : maticneList) {
                File f = new File(dir);
                File[] matchingFiles = f.listFiles(new FilenameFilter() {
                    public boolean accept(File dir, String name) {
                        return name.startsWith(fileName + "_" + maticna + "_");
                    }
                });
                
                if (matchingFiles.length > 0) {
	                PDFMergerUtility ut = new PDFMergerUtility();
	                for (File ff : matchingFiles) {
	                	ut.addSource(ff);
	                }
	                String ffName = dir+fileName + "_" + maticna + ".pdf";
	                maticnaList.add(ffName);
		            ut.setDestinationFileName(ffName);
		            ut.mergeDocuments(null);
	                for (File ff : matchingFiles) {
	                	ff.delete();
	                }
                }
            }
            
            //pobrisem se vse morebitne ostanke
            /*File f = new File(dir);
            File[] matchingFiles = f.listFiles(new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    return name.startsWith(filePdf + "__");
                }
            });
            for (File ff : matchingFiles) {
            	ff.delete();
            }
            */
            //
			ret = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
	        if (pdDocument != null) {
	            pdDocument.close();
	        }
	    }
		return maticnaList;
	}

	
	
	public static void generateSideBySidePDF(File pdf1File, File pdf2File, int signLocation, int topLoc, int rec, boolean join) {
		PDDocument pdf1 = null;
    	PDDocument pdf2 = null;
	    PDDocument outPdf = null;
	    try {
	        pdf1 = PDDocument.load(pdf1File);
	        pdf2 = PDDocument.load(pdf2File);
	        outPdf = new PDDocument();

	        File outPdfFile = pdf2File;
	        if (join) {
		        int xMaticna = 260;
	            int yMaticna = 20;
	            Rectangle rect = new Rectangle( xMaticna, yMaticna, 50, 10 ); 
	            PDFTextStripperByArea stripper = new PDFTextStripperByArea(); 
	            stripper.setSortByPosition( true ); 
	            stripper.addRegion( "class", rect ); 
	            stripper.extractRegions( pdf1.getPage(0)); 
	            System.out.println( "***********MATICNA***************" );
	            System.out.println( stripper.getTextForRegion( "class" ).trim() );
	            String maticna = stripper.getTextForRegion( "class" ).trim();
	            maticneList.add(maticna);
	            stripper.removeRegion("class");
	            
	    	    outPdfFile = new File(pdf1File.getParent()+"/"+pdf1File.getName().substring(0,pdf1File.getName().lastIndexOf("_"))+"_"+maticna+"_"+rec+".pdf");
	        }
	        
	        // Create output PDF frame
	        PDRectangle pdf1Frame = ((PDPage)pdf1.getDocumentCatalog().getPages().get(0)).getCropBox();
	        PDRectangle pdf2Frame = ((PDPage)pdf2.getDocumentCatalog().getPages().get(0)).getCropBox();
	        
	        PDRectangle outPdfFrame;
	        if (topLoc == 0) {
		        outPdfFrame = new PDRectangle(pdf1Frame.getWidth(), pdf1Frame.getHeight());
	        }
	        else {
		        outPdfFrame = new PDRectangle(pdf1Frame.getWidth(), pdf1Frame.getHeight()+pdf2Frame.getHeight());
	        }

	        // Create output page with calculated frame and add it to the document
	        COSDictionary dict = new COSDictionary();
	        dict.setItem(COSName.TYPE, COSName.PAGE);
	        dict.setItem(COSName.MEDIA_BOX, outPdfFrame);
	        dict.setItem(COSName.CROP_BOX, outPdfFrame);
	        dict.setItem(COSName.ART_BOX, outPdfFrame);
	        PDPage outPdfPage = new PDPage(dict);
	        outPdf.addPage(outPdfPage);

	        // Source PDF pages has to be imported as form XObjects to be able to insert them at a specific point in the output page
	        LayerUtility layerUtility = new LayerUtility(outPdf);
	        PDFormXObject formPdf1 = layerUtility.importPageAsForm(pdf1, 0);
	        PDFormXObject formPdf2 = layerUtility.importPageAsForm(pdf2, 0);

	        // Add form objects to output page
	        //AffineTransform afTop = new AffineTransform();
	        AffineTransform afTop = AffineTransform.getTranslateInstance(0.0, topLoc);
	        layerUtility.appendFormAsLayer(outPdfPage, formPdf1, afTop, "top");
	        System.out.println( "signLocation="+signLocation );
	        AffineTransform afBottom = AffineTransform.getTranslateInstance(0.0, signLocation);
	        if (!join) {
	        	if (topLoc == 0) {
	        		afBottom = AffineTransform.getTranslateInstance(0.0, -signLocation+85);
	        	}
	        	else {
	        		afBottom = AffineTransform.getTranslateInstance(0.0, signLocation);
	        	}
	        }
	        layerUtility.appendFormAsLayer(outPdfPage, formPdf2, afBottom, "bottom");

	        System.out.println( "outPdfFile="+outPdfFile );
            
	        outPdf.save(outPdfFile);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (pdf1 != null) pdf1.close();
	            if (pdf2 != null) pdf2.close();
	            if (outPdf != null) outPdf.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
	}


	
	@Override
	protected void processTextPosition(TextPosition text) {
	    String tChar = text.getUnicode();
	    /*System.out.println("String[" + text.getXDirAdj() + ","
	            + text.getYDirAdj() + " fs=" + text.getFontSize() + " xscale="
	            + text.getXScale() + " height=" + text.getHeightDir() + " space="
	            + text.getWidthOfSpace() + " width="
	            + text.getWidthDirAdj() + "]" + text.getUnicode());*/
	    String REGEX = "[,.\\[\\](:;!?)/]";
	    char c = tChar.charAt(0);
	    lineMatch = matchCharLine(text);
	    if ((!tChar.matches(REGEX)) && (!Character.isWhitespace(c))) {
	        if ((!is1stChar) && (lineMatch == true)) {
	            appendChar(tChar);
	        } else if (is1stChar == true) {
	            setWordCoord(text, tChar);
	        }
	    } else {
	        endWord();
	    }
	}

	protected void appendChar(String tChar) {
	    tWord.append(tChar);
	    is1stChar = false;
	}

	protected void setWordCoord(TextPosition text, String tChar) {
	    tWord.append(pageNo)
	    	.append("_")
	    	.append(Math.round(Float.valueOf(text.getYDirAdj())))
	    	.append("_")
	    	.append(tChar);
	    is1stChar = false;
	}

	protected void endWord() {
		String newWord = tWord.toString();//.replaceAll("[^\\x00-\\x7F]", "");
	    String sWord = newWord.substring(newWord.lastIndexOf('_') + 1);
	    if (!"".equals(sWord)) {
	    	//System.out.println(sWord);
	    	if (Arrays.asList(seek).contains(sWord)) {
	            wordList.add(newWord);
	        }
	    }
	    tWord.delete(0, tWord.length());
	    is1stChar = true;
	}

	protected boolean matchCharLine(TextPosition text) {
	    Double yVal = roundVal(Float.valueOf(text.getYDirAdj()));
	    if (yVal.doubleValue() == lastYVal) {
	        return true;
	    }
	    lastYVal = yVal.doubleValue();
	    endWord();
	    return false;
	}

	protected Double roundVal(Float yVal) {
	    DecimalFormat rounded = new DecimalFormat("0.0'0'");
	    //Double yValDub = new Double(rounded.format(yVal));
	    Double yValDub = new Double(yVal);
	    return yValDub;
	}
}
