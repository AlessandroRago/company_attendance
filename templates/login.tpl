<!-- Index.html file -->
<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport"
		content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet"
		href="style.css">
	<title>QR Code Scanner / Reader
	</title>
</head>

<body>
	<div class="container">
		<h1>Scan QR Codes</h1>
		<div class="section">
			<div id="my-qr-reader">
			</div>

		</div>
		<a href="index.php?action=generator">Add new account</a>
		<?php if($mode == 'exit'): ?>
		<a href="index.php?mode=enter">Switch to enter mode</a>
		<?php endif;?>
		<?php if($mode == 'enter'): ?>
		<a href="index.php?mode=exit">Switch to EXIT mode</a>
		<?php endif;?>
	</div>

	<script
		src="https://unpkg.com/html5-qrcode">
	</script>
	<script src="../script.js"></script>
</body>

</html>
