
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
    	alert(csv);  

    	var result = syncAjax('/papirservis/StrankeServlet', null, true, ('csv='+csv));
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
