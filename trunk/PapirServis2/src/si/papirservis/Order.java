package si.papirservis;

import com.sun.istack.internal.NotNull;

public class Order {

	public Order(){
		
	}
	
	private String stDob;

	private String datum;

	private String kamion;

	private String stranke_sif_str;

	private String stranke_x_koord;

	private String stranke_y_koord;

	private String enote_x_koord;

	private String enote_y_koord;

	private String zacetek;

	private String konec;
	
	private int meters;

	public String getStDob() {
		return stDob;
	}

	public void setStDob(String stDob) {
		this.stDob = stDob;
	}

	public String getDatum() {
		return datum;
	}

	public void setDatum(String datum) {
		this.datum = datum;
	}

	public String getKamion() {
		return kamion;
	}

	public void setKamion(String kamion) {
		this.kamion = kamion;
	}

	public String getStranke_sif_str() {
		return stranke_sif_str;
	}

	public void setStranke_sif_str(String stranke_sif_str) {
		this.stranke_sif_str = stranke_sif_str;
	}

	public String getStranke_x_koord() {
		return stranke_x_koord;
	}

	public void setStranke_x_koord(String stranke_x_koord) {
		this.stranke_x_koord = stranke_x_koord;
	}

	public String getStranke_y_koord() {
		return stranke_y_koord;
	}

	public void setStranke_y_koord(String stranke_y_koord) {
		this.stranke_y_koord = stranke_y_koord;
	}

	public String getEnote_x_koord() {
		return enote_x_koord;
	}

	public void setEnote_x_koord(String enote_x_koord) {
		this.enote_x_koord = enote_x_koord;
	}

	public String getEnote_y_koord() {
		return enote_y_koord;
	}

	public void setEnote_y_koord(String enote_y_koord) {
		this.enote_y_koord = enote_y_koord;
	}

	public String getZacetek() {
		return zacetek;
	}

	public void setZacetek(String zacetek) {
		this.zacetek = zacetek;
	}

	public String getKonec() {
		return konec;
	}

	public void setKonec(String konec) {
		this.konec = konec;
	}

	public int getMeters() {
		return meters;
	}

	public void setMeters(int meters) {
		this.meters = meters;
	}


	
}