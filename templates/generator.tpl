<!DOCTYPE html>
<html lang="it">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Badge con QR Code</title>
    <!-- Includi la libreria QRCode.js -->
    <script src="https://cdn.rawgit.com/davidshimjs/qrcodejs/gh-pages/qrcode.min.js"></script>
    <style>
        #password {
            display: none;
        }
        /* Stili per il badge */
        #badge {
            display: inline-block;
            padding: 20px;
            background-color: #f0f0f0;
            border: 2px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            position: relative;
        }

        #badgeText {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        #qrcode {
            margin: 0 auto;
        }

        /* Stili per il pulsante */
        #downloadButton {
            display: block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        #downloadButton:hover {
            background-color: #0056b3;
        }

        /* Stili per i campi di input */
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>

<body>
<!-- Form per inserire Nome, Cognome e Password -->
<form class="form" action="index.php?action=new_user" method="post">
    <input type="text" name="firstName"  id="firstName" placeholder="Nome">
    <input type="text" name="lastName"  id="lastName" placeholder="Cognome">
    <input type="text" name="password"  id="password" placeholder="password" value="<?=$password?>">
    <input class="btn btn-primary" type="submit" id="downloadButton" value="Invia credenziali">
</form>
<div hidden="hidden" id="psw"><?=$password?></div>
<!-- Div per il badge con QR code -->
<div id="badge">
    <!-- Testo del badge -->
    <div id="badgeText">
        Nome Cognome
    </div>
    <!-- QR code del badge -->
    <div id="qrcode"></div>
</div>

<!-- Pulsante per scaricare l'immagine del badge -->
<script type="text/javascript">
    // Funzione per creare il QR code e aggiungerlo al badge
    function createQRCode() {
        var qrCodeDiv = document.getElementById("qrcode"); // Div per il QR code
        qrCodeDiv.innerHTML = ''; // Svuota il contenuto del div
        var password = document.getElementById("psw").innerHTML;
        var text = `${password}`; // Testo per il QR code
        new QRCode(qrCodeDiv, text); // Crea il QR code nel div
    }


    // Funzione per scaricare il badge come immagine
    function downloadBadge() {
        // Crea un canvas temporaneo
        var canvas = document.createElement("canvas");
        var ctx = canvas.getContext("2d");

        // Calcola le dimensioni del badge
        var badgeWidth = document.getElementById("badge").offsetWidth;
        var badgeHeight = document.getElementById("badge").offsetHeight;

        // Imposta le dimensioni del canvas
        canvas.width = badgeWidth;
        canvas.height = badgeHeight;

        // Disegna il badge sul canvas
        ctx.fillStyle = "white";
        ctx.fillRect(0, 0, badgeWidth, badgeHeight);

        // Disegna il Nome e Cognome sopra il badge
        var firstName = document.getElementById("firstName").value;
        var lastName = document.getElementById("lastName").value;
        ctx.fillStyle = "black";
        ctx.font = "18px Arial";
        ctx.fillText(firstName + " " + lastName, 10, 30);

        // Disegna il QR code
        var qrCodeImage = document.getElementById("qrcode").querySelector("img");
        var qrCodeX = (badgeWidth - qrCodeImage.width) / 2;
        var qrCodeY = (badgeHeight - qrCodeImage.height) / 2;
        ctx.drawImage(qrCodeImage, qrCodeX, qrCodeY);

        // Crea un link per il download dell'immagine
        var link = document.createElement("a");
        link.download = "badge.png"; // Nome del file da scaricare
        link.href = canvas.toDataURL("image/png");

        // Aggiungi il link al documento e fai clic automaticamente
        document.body.appendChild(link);
        link.click();

        // Rimuovi il link dal documento
        document.body.removeChild(link);
    }

    // Chiama la funzione per creare il QR code quando il documento è pronto
    document.addEventListener("DOMContentLoaded", function () {
        createQRCode();

        // Aggiungi l'evento click al pulsante di download
        document.getElementById("downloadButton").addEventListener("click", function () {
            downloadBadge();
        });
    });
    // Funzione per aggiornare il badge e il QR code quando vengono inseriti i dati dall'utente
    function updateBadge() {
        createQRCode(); // Aggiorna il QR code
        updateBadgeText(); // Aggiorna il testo del badge
    }

    // Funzione per aggiornare il testo del badge con Nome e Cognome inseriti dall'utente
    function updateBadgeText() {
        var firstName = document.getElementById("firstName").value;
        var lastName = document.getElementById("lastName").value;
        var badgeText = `${firstName} ${lastName}`; // Testo del badge
        document.getElementById("badgeText").innerText = badgeText; // Aggiorna il testo del badge
    }

    // Chiama la funzione per aggiornare il badge quando vengono inseriti i dati dall'utente
    document.getElementById("firstName").addEventListener("input", updateBadge);
    document.getElementById("lastName").addEventListener("input", updateBadge);
    document.getElementById("password").addEventListener("input", updateBadge);
</script>
</body>

</html>