<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="../style/style.css">
	<title>¡Pitumundo!</title>
</head>
<body>
	<h1>Hoy en pitumundo, hemos elegido a: Papá pitufo</h1>
	<form action="p3.php" method="POST">
		<div>
			<label>Nombre: </label>
			<input type="text" name="nombre" value="<?php echo $_POST["nombre"]; ?>" readonly>
		</div>
		<div>
			<label>Apellido: </label>
			<input type="text" name="apellido" value="<?php echo $_POST["apellido"]; ?>" readonly>
		</div>
		<div>
			<label>Edad: </label>
			<input type="number" name="edad" placeholder="100">
		</div>
		<div>
			<label>Número de la suerte: </label>
			<input type="number" name="número" placeholder="Entre 0 y 9 (incluyendo)">
		</div>
		<button type="submit">Enviar!</button>
	</form>
	<img src="<?php
		$traductorImágenes = [
			"1.jpg",
			"2.jpeg",
			"3.webp",
			"4.webp"
		];

		echo "../img/" . $traductorImágenes[rand(1, 3)];
	?>" alt="Papá pitu">
</body>
</html>