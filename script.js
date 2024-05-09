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
function prova(password) {
	var nuovaURL = "index.php/?action=Authorization";
	var xhr = new XMLHttpRequest();
	xhr.open("POST", nuovaURL, true);
	xhr.onreadystatechange = function () {
		if (xhr.readyState === 4 && xhr.status === 200) {
			console.log("Risposta dal server:", xhr.responseText);
		}
	};
	xhr.send(password);
}

domReady(function () {
	function sendAuth(password){
		const url = 'index.php';

		let data = new URLSearchParams();
		data.append('password', password);

		const options = {
			headers: {
				'Accept': 'text/html',
				'Content-Type': 'text/html'
			},
			method: `POST`,
			body: data
		};

		fetch(url, options)
			.then(data => {
				//window.location.href = "index.php"
			});
	}
	function onScanSuccess(decodeText) {
		let password = decodeText
		console.log(password)
		//cambiaActionNuovoValore("Authorization");
		//sendAuth(password)
		prova(password)
		window.location.href = "index.php?action=Authorization"

	}

	let htmlscanner = new Html5QrcodeScanner(
		"my-qr-reader",
		{ fps: 10, qrbos: 250 }
	);
	htmlscanner.render(onScanSuccess);
});
