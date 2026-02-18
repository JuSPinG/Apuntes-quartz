<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
</head>
<body>
	<form action="P0202.php" method="post">
		<div>
			Nombre: <input type="text" name="nombre1">
			<br>
			Contraseña: <input type="password" name="pass1">
			<br>
			Imagen: <input type="text" name="img1">
		</div>
		<div>
			<input type="submit" value="Dame rico">
		</div>
	</form>
	<input type="number" value=<?php echo $_POST["n1"] + 1; ?> readonly>
</body>
</html>