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

    	var result = syncAjax('/kovine/StrankeServlet', null, true, ('type=import&csv='+encodeURIComponent(csv)));
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
	
	document.getElementById('strankelist').action = '/kovine/StrankeServlet?type=export&tipizvoza='+tipizvoza;
	document.getElementById('strankelist').submit();
	
//	var result = syncAjax('/kovine/StrankeServlet', 'text/csv', true, ('type=export&tipizvoza='+tipizvoza));
//	alert(result);
}

function arsoPrepareXML(keys, tabela, sif_upor, od_datum, do_datum, skupina, uporabnik, xml_create) {
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
	
	document.getElementById('arsopaketinew').action = '/kovine/ArsoPrepareXMLServlet?key=null&tabela='+tabela+'&sif_upor='+sif_upor+'&keyChecked='+keyChecked+'&od_datum='+od_datum+'&do_datum='+do_datum+'&skupina='+skupina+'&uporabnik='+uporabnik+'&xml_create='+xml_create;
	document.getElementById('arsopaketinew').submit();
	
	
	/*var result = syncAjax('/kovine/ArsoPrepareXMLServlet', null, true, ('tabela='+tabela+'&sif_upor='+sif_upor+'&keyChecked='+keyChecked+'&od_datum='+od_datum+'&do_datum='+do_datum+'&skupina='+skupina));

	if(result == "false") 
		alert("Prišlo je do napake pri pripravi podatkov.");
	else {
		alert("Datoteka "+result+" je uspešno pripravljena.");
		document.getElementById('arsopaketinew').action = '/kovine/paketi/'+result;
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

function izberiVse2(tip, id) {
	var keys = document.getElementById(id).key;
	for (var i = 0; i < keys.length; i++){
		var key = keys.item(i);
		key.checked = tip;
	}
}


function zbrisiPaket(key) {
	var result = syncAjax('/kovine/ArsoPrepareXMLServlet', null, true, ('key='+key));

	if(result == "false") {
		alert("Prišlo je do napake pri brisanju paketa.");
		return false;
	} else {
		alert("Datoteka je uspešno zbrisana.");
	}
}

function xls_create(sql) {
	document.getElementById('dobForm').action = '/kovine/XLSCreateServlet?sql='+sql;
	document.getElementById('dobForm').submit();
	document.getElementById('dobForm').action = 'doblist.jsp';
}

function xls_create_prodaja(sql) {
	document.getElementById('dobForm').action = '/kovine/XLSCreateProdajaServlet?sql='+sql;
	document.getElementById('dobForm').submit();
	document.getElementById('dobForm').action = 'prodajalist.jsp';
}

function xls_create_komunala(param1, param2) {
	document.getElementById('komunalaForm').action = '/kovine/XLSCreateKomunalaServlet?param1='+param1+"&param2="+param2;
	document.getElementById('komunalaForm').submit();
	document.getElementById('komunalaForm').action = 'komunalakolicinelist.jsp';
}

function sendEvls() {
	alert("Po kliku počakajte da se EVL-ji pripravijo in pošljejo. Po končanju boste dobili obvestilo.");
	
/*	var event = $(document).click(function(e) {
	    e.stopPropagation();
	    e.preventDefault();
	    e.stopImmediatePropagation();
	    return false;
	});*/
	

	// disable right click
	/*document.addEventListener("contextmenu", function(e){
	    e.stopPropagation();
	    e.preventDefault();
	    e.stopImmediatePropagation();
	}, false);*/
	
	document.onclick=DisableRightClick;
	document.onmouseup=DisableRightClick;
	document.onmousedown=DisableRightClick;
	prvic = true;
	
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/papirservis/ArsoPosiljanjeServlet', true);
	xhr.onload = function () {
	  if (xhr.status === 200) {
	    alert('Evl-ji uspešno poslani.');
	    var res = xhr.responseText.split("|", 2);
	    window.location.href = "/papirservis/" + res[1];
		setTimeout(function() {
		    document.getElementById('arsoposiljanje').action = 'arsoposiljanjelist.jsp?a=U&evls='+str+'&arso_paket='+ res[0];
			document.getElementById('arsoposiljanje').submit();
		}, 100);
	  } else {
	    alert('Napaka pri pošiljanju evl-jev!');
	  }
	};
	xhr.send(formData);
}

var prvic = true;
function DisableRightClick(e) 
{
	if(e.button == 0)
	{
		if (!prvic) alert ("Počakaj da končam");
		prvic = false;
		return false;
	}
	if(e.button == 1)
	{
		alert ("Počakaj da končam");
		return false;
	}
	if(e.button == 2)
	{
		alert ("Počakaj da končam");
		return false;
	}
}



function mail(keys, receiver, msg, tabela, user, sender) {
	keyChecked = "";
	if (keys.length == undefined) {
		keyChecked = "" + keys.value;
	}
	else {
		for (var i = 0; i < keys.length; i++){
			var key = keys.item(i);
			if (key.checked) {
				if (keyChecked != "") {
					keyChecked += "," + key.value;
				} else {
					keyChecked += key.value;
				}
			}
		}
	}
	document.getElementById('dobavnicalistform').action = '/kovine/MailServlet?tabela='+tabela+'&key='+keyChecked+'&receiver='+receiver+'&msg='+msg+'&user='+user+'&sender='+sender;
	document.getElementById('dobavnicalistform').submit();
	//document.getElementById('dobavnicalistform').action = 'dobavnicalist.jsp';
	
}