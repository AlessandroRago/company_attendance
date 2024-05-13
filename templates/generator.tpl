<!DOCTYPE html>
<html lang="it">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Badge con QR Code</title>
    <!-- Includi la libreria QRCode.js -->
    <script src="https://cdn.rawgit.com/davidshimjs/qrcodejs/gh-pages/qrcode.min.js"></script>
    <style>

        body {
            font-family: 'Arial', sans-serif;
            background: radial-gradient(circle, rgba(32,32,36,1) 0%, rgba(22,22,24,1) 100%);
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-right: 20px;
        }

        #badge {
            display: inline-block;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        #badgeText {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
        }

        #qrcode {
            margin: 10px auto;
        }

        input[type="text"],
        input[type="password"],
        input[type="number"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        #downloadButton {
            display: block;
            width: 100%;
            padding: 10px 0;
            background: linear-gradient(to right, #ee4235, #f5ab3e);
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.5s ease, background-color 0.5s ease, box-shadow 0.5s ease;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }

        #downloadButton:hover {
            transform: scale(1.02);
            background: linear-gradient(to right, #f56a4e, #f7c258);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.4);
        }
    </style>
</head>

<body>
<!-- Form per inserire Nome, Cognome e Password -->
<form class="form" action="index.php?action=new_user" method="post">
    <input type="text" name="firstName"  id="firstName" placeholder="Nome">
    <input type="text" name="lastName"  id="lastName" placeholder="Cognome">
    <input type="text" name="password"  hidden="hidden" id="password" placeholder="password" value="<?=$password?>">
    <input type="number" name="hourlyWage" id="hourlyWage" placeholder="Stipendio orario" min="0" step="0.01">
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
    <img src="logo0.png" id="logoImage" style="width: auto; height: auto; margin: 10px auto;"> <!-- Assicurati che le dimensioni siano appropriate -->
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

        // Crea un elemento img per il logo
        var logoImage = new Image();
        logoImage.onload = function() {
            var logoX = (badgeWidth - logoImage.width) / 2;
            var logoY = qrCodeY + qrCodeImage.height + 10; // Posiziona il logo 10px sotto il QR code
            ctx.drawImage(logoImage, logoX, logoY);

            // Crea un link per il download dell'immagine
            var link = document.createElement("a");
            link.download = "badge.png"; // Nome del file da scaricare
            link.href = canvas.toDataURL("image/png");

            // Aggiungi il link al documento e fai clic automaticamente
            document.body.appendChild(link);
            link.click();

            // Rimuovi il link dal documento
            document.body.removeChild(link);
        };
        logoImage.src = 'logo0.png'; // Assicurati che il percorso sia corretto
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