function domReady(fn) {
	if (
		document.readyState === "complete" ||
		document.readyState === "interactive"
	) {
		setTimeout(fn, 1000);
	} else {
		document.addEventListener("DOMContentLoaded", fn);
	}
}

function cambiaActionNuovoValore(action) {
	var nuovaURL = "index.php?action=" + encodeURIComponent(action);
	var xhr = new XMLHttpRequest();
	xhr.open("GET", nuovaURL, true);
	xhr.onreadystatechange = function () {
		if (xhr.readyState === 4 && xhr.status === 200) {
			console.log("Risposta dal server:", xhr.responseText);
		}
	};
	xhr.send();
}

domReady(function () {

	function onScanSuccess(decodeText, decodeResult) {
		var message = "You Qr is : " + decodeText + " " + decodeResult;
		alert(message);
		cambiaActionNuovoValore("Authorization");
	}

	let htmlscanner = new Html5QrcodeScanner(
		"my-qr-reader",
		{ fps: 10, qrbos: 250 }
	);
	htmlscanner.render(onScanSuccess);
});
