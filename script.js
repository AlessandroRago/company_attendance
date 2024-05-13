
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

		if (window.location.href.includes("index.php?mode=exit")) {
			// Creazione dell'overlay
			var overlay = document.createElement('div');
			overlay.id = 'overlay';

			// Creazione del form
			var form = document.createElement('form');
			form.id = 'exitForm';
			form.action = 'index.php?action=Authorization&mode=exit'
			form.method = "post"
			// Aggiunta dei campi al form
			var selectJust = document.getElementById("justificationSelect");
			selectJust.hidden = false;
			//selectJust.type = 'text';
			selectJust.name = 'justification';
			selectJust.className = "button"
			//selectJust.placeholder = "1";
let pls = document.createElement("a");
			var submitButton = document.createElement('input');
			submitButton.type = 'submit';
			submitButton.className = "button"
			submitButton.value = 'Invia';
			pls.appendChild(submitButton)
			pls.onclick = function() {
				// Rimuovere l'overlay quando si fa clic sul link di chiusura
				prova(password)
				return false; // Per impedire il comportamento predefinito del link
			};
			// Aggiunta dei campi al form
			form.appendChild(selectJust);
			form.appendChild(submitButton);

			// Creazione del link di chiusura
			var closeButton = document.createElement('a');
			closeButton.textContent = 'Close';
			closeButton.onclick = function() {
				// Rimuovere l'overlay quando si fa clic sul link di chiusura
				overlay.remove();
				window.location.href="index.php?mode=exit"
				return false; // Per impedire il comportamento predefinito del link
			};

			// Aggiunta del link di chiusura al form
			form.appendChild(closeButton);

			// Aggiunta del form all'overlay
			overlay.appendChild(form);

			// Aggiunta dell'overlay al body del documento
			document.body.appendChild(overlay);
		}
		else {
			prova(password)
			window.location.href = "index.php?action=Authorization&mode=enter"
		}

	}

	let htmlscanner = new Html5QrcodeScanner(
		"my-qr-reader",
		{ fps: 10, qrbos: 250 }
	);
	htmlscanner.render(onScanSuccess);
});
