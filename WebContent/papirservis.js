if (window.File && window.FileReader && window.FileList && window.Blob) {
	//Great success! All the File APIs are supported.
} else {
	alert('The File APIs are not fully supported in this browser.');
}

syncAjax = function (url, contentType, isPost, postContent) {
	   var http_request = false;
	   http_request = false;
	   if (window.XMLHttpRequest) { // Mozilla, Safari,...
	      http_request = new XMLHttpRequest();
	      if (http_request.overrideMimeType) {
	         http_request.overrideMimeType('text/html');
	      }
	   } else if (window.ActiveXObject) { // IE
	      try {
	         http_request = new ActiveXObject("Msxml2.XMLHTTP");
	      } catch (e) {
	         try {
	            http_request = new ActiveXObject("Microsoft.XMLHTTP");
	         } catch (e) {}
	      }
	   }
	   if (!http_request) {
	      alert('Cannot create XMLHTTP instance');
	      return false;
	   }
	   try {
	   	   var httpMethod = isPost ? "POST" : "GET";
	   	   var httpBody = isPost ? postContent : null;
	   	   http_request.open(httpMethod, url, false);
	   	   if (isPost) {
	   	   	   http_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
	   	   } else {
		   	   if (contentType) {
		   	   		http_request.setRequestHeader("Content-type", contentType);
		   	   } else {
		   	   		http_request.setRequestHeader("Content-type", "text/html; charset=utf-8");
		   	   }
	   	   }
		   //http_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
		   http_request.send(httpBody);
		   return http_request.responseText;
	   } catch (e) {
	   //console.info(e);
	   		return false;
	   }
}


document.getElementById('csvfile').addEventListener('change', handleFileSelect, false);

function handleFileSelect(evt) {
	var files = evt.target.files; // FileList object


	var f = files[0];
    if (!f.name.match('\.csv')) {
   	  alert("Napačen format datoteke");
   	  return;
    }

    
    var reader = new FileReader();
    // Closure to capture the file information.
    reader.onload = (function(theFile) {
      return function(e) {
    	var csv = e.target.result;
    	//alert(csv);  

    	var result = syncAjax('/papirservis/StrankeServlet', null, true, ('type=import&csv='+encodeURIComponent(csv)));
    	if(result = true) {
    		alert("Podatki uspešno shranjeni.");
    		document.getElementById('strankelist').submit();
    	}	
    	else
    		alert("Prišlo je do napake pri shranjevanju podatkov.");
      };
    })(f);

    var xml = reader.readAsText(f);
};

function strankeExport() {
	var vsi = document.getElementById('vsi').checked;
	var novi = document.getElementById('novi').checked;
	var tipizvoza="vsi";
	if (novi) tipizvoza="novi";
	
	document.getElementById('strankelist').action = '/papirservis/StrankeServlet?type=export&tipizvoza='+tipizvoza;
	document.getElementById('strankelist').submit();
	
//	var result = syncAjax('/papirservis/StrankeServlet', 'text/csv', true, ('type=export&tipizvoza='+tipizvoza));
//	alert(result);
}

function arsoPrepareXML(keys, tabela, sif_upor, od_datum, do_datum, skupina, uporabnik, xml_create) {
	alert(keys.value);
	keyChecked = "";
	if (keys.length == undefined) {
		keyChecked = "'" + keys.value + "'";
	}
	else {
		for (var i = 0; i < keys.length; i++){
			var key = keys.item(i);
			if (key.checked) {
				if (keyChecked != "") {
					keyChecked += ",'" + key.value + "'";
				} else {
					keyChecked += "'" + key.value + "'";
				}
			}
		}
	}
	alert(keyChecked);

	document.getElementById('arsopaketinew').action = '/papirservis/ArsoPrepareXMLServlet?key=null&tabela='+tabela+'&sif_upor='+sif_upor+'&keyChecked='+keyChecked+'&od_datum='+od_datum+'&do_datum='+do_datum+'&skupina='+skupina+'&uporabnik='+uporabnik+'&xml_create='+xml_create;
	document.getElementById('arsopaketinew').submit();
	
	
	/*var result = syncAjax('/papirservis/ArsoPrepareXMLServlet', null, true, ('tabela='+tabela+'&sif_upor='+sif_upor+'&keyChecked='+keyChecked+'&od_datum='+od_datum+'&do_datum='+do_datum+'&skupina='+skupina));

	if(result == "false") 
		alert("Prišlo je do napake pri pripravi podatkov.");
	else {
		alert("Datoteka "+result+" je uspešno pripravljena.");
		document.getElementById('arsopaketinew').action = '/papirservis/paketi/'+result;
		document.getElementById('arsopaketinew').submit();
	}*/
	
//	izberiVse(keys, false);
}

function izberiVse(keys, tip) {
	for (var i = 0; i < keys.length; i++){
		var key = keys.item(i);
		key.checked = tip;
	}
}

function izberiVse2(tip) {
	var keys = document.getElementById('arsopaketinew').key;
	for (var i = 0; i < keys.length; i++){
		var key = keys.item(i);
		key.checked = tip;
	}
}

function zbrisiPaket(key) {
	var result = syncAjax('/papirservis/ArsoPrepareXMLServlet', null, true, ('key='+key));

	if(result == "false") {
		alert("Prišlo je do napake pri brisanju paketa.");
		return false;
	} else {
		alert("Datoteka je uspešno zbrisana.");
	}
}

function xls_create(sql) {
	document.getElementById('dobForm').action = '/papirservis/XLSCreateServlet?sql='+sql;
	document.getElementById('dobForm').submit();
	document.getElementById('dobForm').action = 'doblist.jsp';
}